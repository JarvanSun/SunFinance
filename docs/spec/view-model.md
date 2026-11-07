# ViewModels

A ViewModel holds the state of one screen and every decision about it. What can be decided
without SwiftUI is decided here, so a unit test covers it.

## Shape

- Every screen that loads data, has more than one state, tracks an action or navigates has one. A
  view that only lays out values it was given has none.
- `@Observable final class <Screen>ViewModel`, `internal`, in the screen's folder.
- Imports Foundation, Observation and FinanceCore, plus DesignSystem for its state values
  (`LoadState`, `RangedHistory`). Never SwiftUI or SunUserInterface; never reads Environment.
- Created by the navigation host or the router, owned with `@State`, passed down as
  `let viewModel` or `@Bindable var viewModel`.
- Every dependency is an `init` parameter typed as its protocol and stored as
  `private let … : Protocol` (`any` / `some` only where the compiler needs them, as for
  `any Clock<Duration>`): starting values first (a symbol, a range), services next, router
  and tracker last. No default arguments; previews and tests pass their own.

## State

- Stored state is `private(set) var`. The only writable `var`s are values a view binds to
  (`searchText`).
- What the screen is doing is one enum (`WatchlistActivity`: `idle`, `loading`, `loaded`,
  `failed(WatchlistIssue)`), never `isLoading` plus `error` plus `hasLoaded`. A search beside a
  list is a second activity of the same enum (`searchActivity`).
- A screen with several loads that succeed and fail on their own (quote detail: quote, chart,
  trading) keeps one `LoadState<Value, Issue>` per load instead. A reload keeps a loaded value
  (`reloading`), and so does a failed reload (`settled(with:)`).
- A chart with ranges keeps one `RangedHistory<Range, Value, Issue>`, never its own cache.
  `selectRange(_:)` calls `history.select(_:)`; the load calls `startLoading()` and then
  `settle(with:for:)` with the range it asked for. Its rules:
  - a range loaded before shows at once from the cache;
  - otherwise the previous curve stays in `shown` only as the source the chart morphs from, and
    `selected` stays `nil`, so the header's change is pending and scrubbing reads nothing;
  - a failure for a range without data of its own shows `failed`; a failed refresh keeps data;
  - an answer for a range no longer selected only fills the cache.
- A paged list whose loads can overlap counts its loads (`OrderListLoads`): it shows `loading`
  while any load runs, applies only the newest answer, and a cancelled load only stops counting.
- A failed poll keeps the content and is shown: the screen marks itself stale
  (`PortfolioFreshness.stale(issue)`) until a poll succeeds.
- What the screen shows instead of content is a derived optional enum, `placeholder`, computed
  with one `switch`.
- Lists the view renders are derived, never a second stored copy. Values derived from the same
  filtering and sorting are one value computed once per read (`content: WatchlistContent`).

## Intents

Every user action is one method named after what the user does. An intent guards its
precondition, changes state, tracks, then navigates, in that order, so tracking describes the
state the user saw.

- A picker that needs tracking binds to an intent (`selectSortOrder(_:)`), with the value kept
  `private(set)`.
- Async intents are `async`, called from `.task` / `.task(id:)`, and never create a `Task`. The
  one exception is a write the server may already have carried out when the view's task is
  cancelled: placing an order runs in a `Task` the ViewModel owns
  (`ReviewViewModel.placeOutlivingTheScreen()`), so it always settles with the server's answer,
  and a second request waits for the same `Task`.

## Async loading

- The load step returns a `Result` with the domain error, so the main function stays a straight
  line (`refresh()` below).
- Cancellation is checked once, right after each `await`; a cancelled load changes nothing.
- Old content stays visible during a refresh; `placeholder` shows loading only when there is
  nothing to show.
- What starts a load again is a request value the ViewModel holds (`quotesRequest: UUID`) and the
  view observes with `.task(id:)`. An intent that must reload (`retry()`, `addToWatchlist(_:)`)
  replaces it. A load that depends on several values observes a small `Hashable` request built
  from them (`SymbolSearchRequest`: query and attempt).
- Loads that run together are combined in the ViewModel with `async let`, never in the view.
- Waiting is its own step on the injected clock (`waitForTypingToPause()`), so tests drive it
  with a `ClockSpy`.

## Queries for the view

The view asks; it never computes. A question about an element is a method (`isFavorite(_:)`,
`favoriteAction(for:)`), a question about the screen a property (`placeholder`). Return named
values with presentation, never `Bool` pairs the view turns into strings or symbols.

## Reference implementation

`Features/Watchlist/Sources/Watchlist/Screens/Watchlist/WatchlistViewModel.swift`, shortened:

```swift
@Observable
final class WatchlistViewModel {
    private(set) var symbols: [TickerSymbol]
    private(set) var quotes: [StockQuote] = []
    private(set) var activity: WatchlistActivity = .idle
    private(set) var symbolMatches: [SymbolMatch] = []
    private(set) var searchActivity: WatchlistActivity = .idle
    private(set) var sortOrder: WatchlistSortOrder = .marketCap
    private(set) var favoriteSymbols: Set<TickerSymbol>
    private(set) var quotesRequest = UUID()
    private(set) var searchAttempt = UUID()

    var searchText = ""

    var content: WatchlistContent { ... }

    var searchRequest: SymbolSearchRequest { ... }

    var placeholder: WatchlistPlaceholder? {
        switch (content.hasRows, activity, searchActivity) {
        case (true, _, _): nil
        case (false, .loading, _): .loading
        case (false, .failed(let issue), _): .unavailable(.failed(issue))
        case (false, _, .failed(let issue)) where hasSearchedCurrentQuery:
            .unavailable(.failed(issue))
        case (false, _, .loaded) where hasSearchedCurrentQuery:
            .unavailable(.noSearchResults(query: searchText))
        case (false, _, _) where isSearching: .searching
        case (false, .loaded, _): .unavailable(.empty)
        default: nil
        }
    }

    private let watchlistStore: WatchlistSymbolStoring
    private let quoteProvider: QuoteProviding
    private let symbolSearcher: SymbolSearching
    private let favoriteStore: FavoriteSymbolStoring
    private let clock: any Clock<Duration>
    private let router: WatchlistRouting
    private let tracker: AnalyticsTracking

    private var searchedQuery = ""

    init(
        watchlistStore: WatchlistSymbolStoring,
        quoteProvider: QuoteProviding,
        symbolSearcher: SymbolSearching,
        favoriteStore: FavoriteSymbolStoring,
        clock: some Clock<Duration>,
        router: WatchlistRouting,
        tracker: AnalyticsTracking
    ) { ... }

    func trackScreenView() { ... }

    func refresh() async {
        activity = .loading
        let result = await loadQuotes()
        guard !Task.isCancelled else { return }

        apply(result)
    }

    ...

    func toggleFavorite(_ symbol: TickerSymbol) {
        let isFavorite = favoriteSymbols.toggle(symbol)
        favoriteStore.save(favoriteSymbols)
        tracker.track(WatchlistEvent.favoriteToggled(symbol: symbol, isFavorite: isFavorite))
    }

    ...

    func isFavorite(_ symbol: TickerSymbol) -> Bool { ... }
    func favoriteAction(for symbol: TickerSymbol) -> FavoriteAction { ... }
    func addition(for match: SymbolMatch) -> SymbolAddition { ... }
}

// MARK: - Private

private extension WatchlistViewModel {
    typealias QuoteResult = Result<[StockQuote], MarketDataError>

    var searchDelay: Duration { .milliseconds(300) }

    func loadQuotes() async -> QuoteResult { ... }
    func apply(_ result: QuoteResult) { ... }
    func waitForTypingToPause() async { ... }
    ...
}
```

## Review checklist

- [ ] No `import SwiftUI`.
- [ ] Every stored state property is `private(set)` or deliberately bindable.
- [ ] One activity enum or `LoadState` per independent load; `placeholder` is one `switch`.
- [ ] Every user action is a named intent; every intent that matters tracks an event from
      [analytics.md](analytics.md#what-we-track).
- [ ] Cancellation checked once after each `await`.
