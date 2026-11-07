//
//  WatchlistViewModelTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Watchlist

struct WatchlistViewModelTests {
    @Test func refreshWhenProviderSucceedsThenShowsQuotesAndTracksLoad() async {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(result: .success([appleQuote, sapQuote]), tracker: tracker)

        // When
        await viewModel.refresh()

        // Then
        #expect(viewModel.activity == .loaded)
        #expect(viewModel.content.visibleQuotes == [appleQuote, sapQuote])
        #expect(viewModel.placeholder == nil)
        #expect(tracker.events(of: WatchlistEvent.self) == [.quotesLoaded(count: 2)])
    }

    @Test(arguments: [
        (MarketDataError.offline, WatchlistIssue.offline),
        (.server(statusCode: 503), .serviceUnavailable),
        (.decoding, .unreadableData),
    ])
    func refreshWhenProviderFailsThenShowsIssueAndTracksFailure(
        error: MarketDataError,
        expectedIssue: WatchlistIssue
    ) async {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(result: .failure(error), tracker: tracker)

        // When
        await viewModel.refresh()

        // Then
        #expect(viewModel.activity == .failed(expectedIssue))
        #expect(viewModel.placeholder == .unavailable(.failed(expectedIssue)))
        #expect(tracker.events(of: WatchlistEvent.self) == [.quotesFailed(expectedIssue)])
    }

    @Test func refreshWhenCancelledThenDiscardsResult() async {
        // Given
        let viewModel = makeViewModel(result: .success([appleQuote]))

        // When
        let task = Task { await viewModel.refresh() }
        task.cancel()
        await task.value

        // Then
        #expect(viewModel.quotes.isEmpty)
    }

    @Test func retryThenRequestsQuotesAndSearchAgain() {
        // Given
        let viewModel = makeViewModel()
        let quotesRequest = viewModel.quotesRequest
        let searchRequest = viewModel.searchRequest

        // When
        viewModel.retry()

        // Then
        #expect(viewModel.quotesRequest != quotesRequest)
        #expect(viewModel.searchRequest != searchRequest)
    }

    @Test func placeholderWhenLoadedWithoutQuotesThenIsEmpty() async {
        // Given
        let viewModel = makeViewModel(result: .success([]))

        // When
        await viewModel.refresh()

        // Then
        #expect(viewModel.placeholder == .unavailable(.empty))
    }

    @Test func placeholderBeforeFirstLoadThenIsNil() {
        // When
        let viewModel = makeViewModel()

        // Then
        #expect(viewModel.placeholder == nil)
    }

    @Test func sectionsWhenNotSearchingThenShowWatchlistOnly() async {
        // Given
        let viewModel = makeViewModel(result: .success([appleQuote]))

        // When
        await viewModel.refresh()

        // Then
        #expect(viewModel.content.sections == [.quotes])
    }

    @Test func visibleQuotesWhenSearchingThenMatchesSymbolOrCompanyName() async {
        // Given
        let viewModel = makeViewModel(result: .success([appleQuote, sapQuote]))
        await viewModel.refresh()

        // When
        viewModel.searchText = "app"

        // Then
        #expect(viewModel.content.visibleQuotes == [appleQuote])
    }

    @Test func searchSymbolsThenWaitsForTypingToPauseAndSearchesTrimmedText() async {
        // Given
        let clock = ClockSpy()
        let searcher = SymbolSearcherSpy()
        let viewModel = makeViewModel(searcher: searcher, clock: clock)
        viewModel.searchText = " tes "

        // When
        await viewModel.searchSymbols()

        // Then
        #expect(clock.sleeps == [.milliseconds(300)])
        #expect(searcher.queries == ["tes"])
    }

    @Test func searchSymbolsWhenCancelledWhileWaitingThenNeverSearches() async {
        // Given
        let searcher = SymbolSearcherSpy(result: .success([teslaMatch]))
        let viewModel = makeViewModel(searcher: searcher)
        viewModel.searchText = "Tesla"

        // When
        let task = Task { await viewModel.searchSymbols() }
        task.cancel()
        await task.value

        // Then
        #expect(searcher.queries.isEmpty)
        #expect(viewModel.symbolMatches.isEmpty)
    }

    @Test func searchSymbolsWhenQueryIsBlankThenClearsMatchesWithoutSearching() async {
        // Given
        let searcher = SymbolSearcherSpy(result: .success([teslaMatch]))
        let viewModel = makeViewModel(searcher: searcher)
        viewModel.searchText = "Tesla"
        await viewModel.searchSymbols()

        // When
        viewModel.searchText = "  "
        await viewModel.searchSymbols()

        // Then
        #expect(searcher.queries == ["Tesla"])
        #expect(viewModel.symbolMatches.isEmpty)
        #expect(viewModel.searchActivity == .idle)
    }

    @Test func searchSymbolsWhenFoundThenOffersOnlyStocksNotShownFromTheWatchlist() async {
        // Given
        let viewModel = makeViewModel(
            result: .success([appleQuote, sapQuote]),
            searcher: SymbolSearcherSpy(result: .success([appleMatch, teslaMatch]))
        )
        await viewModel.refresh()
        viewModel.searchText = "Inc"

        // When
        await viewModel.searchSymbols()

        // Then
        #expect(viewModel.content.visibleQuotes == [appleQuote])
        #expect(viewModel.content.addableMatches == [teslaMatch])
        #expect(viewModel.content.sections == [.quotesMatchingSearch, .symbolMatches])
        #expect(viewModel.placeholder == nil)
    }

    @Test func placeholderWhileSearchRunsThenShowsSearching() async {
        // Given
        let viewModel = makeViewModel(result: .success([appleQuote]))
        await viewModel.refresh()

        // When
        viewModel.searchText = "Tesla"

        // Then
        #expect(viewModel.placeholder == .searching)
    }

    @Test func placeholderWhenSearchFindsNothingThenShowsNoSearchResults() async {
        // Given
        let viewModel = makeViewModel(result: .success([appleQuote]))
        await viewModel.refresh()
        viewModel.searchText = "Tesla"

        // When
        await viewModel.searchSymbols()

        // Then
        #expect(viewModel.placeholder == .unavailable(.noSearchResults(query: "Tesla")))
    }

    @Test func placeholderWhenSearchFailsAndNothingMatchesThenShowsFailure() async {
        // Given
        let viewModel = makeViewModel(
            result: .success([appleQuote]),
            searcher: SymbolSearcherSpy(result: .failure(.offline))
        )
        await viewModel.refresh()
        viewModel.searchText = "Tesla"

        // When
        await viewModel.searchSymbols()

        // Then
        #expect(viewModel.searchActivity == .failed(.offline))
        #expect(viewModel.placeholder == .unavailable(.failed(.offline)))
    }

    @Test func submitSearchWhenSearchingThenTracksResultCount() async {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(
            result: .success([appleQuote, sapQuote]),
            searcher: SymbolSearcherSpy(result: .success([teslaMatch])),
            tracker: tracker
        )
        await viewModel.refresh()
        viewModel.searchText = "SAP"
        await viewModel.searchSymbols()

        // When
        viewModel.submitSearch()

        // Then
        #expect(tracker.events(of: WatchlistEvent.self).last == .searchSubmitted(resultCount: 2))
    }

    @Test func submitSearchWhenSearchTextIsBlankThenDoesNotTrack() {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)
        viewModel.searchText = "   "

        // When
        viewModel.submitSearch()

        // Then
        #expect(tracker.events(of: WatchlistEvent.self).isEmpty)
    }

    @Test func addToWatchlistThenSavesRequestsQuotesAndTracks() {
        // Given
        let watchlistStore = WatchlistSymbolStoreSpy(symbols: ["AAPL"])
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(watchlistStore: watchlistStore, tracker: tracker)
        let quotesRequest = viewModel.quotesRequest

        // When
        viewModel.addToWatchlist(teslaMatch)

        // Then
        #expect(viewModel.symbols == ["AAPL", "TSLA"])
        #expect(watchlistStore.savedSymbols == [["AAPL", "TSLA"]])
        #expect(viewModel.quotesRequest != quotesRequest)
        #expect(viewModel.addition(for: teslaMatch) == .added)
        #expect(tracker.events(of: WatchlistEvent.self) == [.symbolAdded(symbol: "TSLA")])
    }

    @Test func addToWatchlistWhenAlreadyOnWatchlistThenChangesNothing() {
        // Given
        let watchlistStore = WatchlistSymbolStoreSpy(symbols: ["AAPL"])
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(watchlistStore: watchlistStore, tracker: tracker)

        // When
        viewModel.addToWatchlist(appleMatch)

        // Then
        #expect(viewModel.symbols == ["AAPL"])
        #expect(watchlistStore.savedSymbols.isEmpty)
        #expect(tracker.events(of: WatchlistEvent.self).isEmpty)
    }

    @Test func additionWhenNotOnWatchlistThenIsAvailable() {
        // Given
        let viewModel = makeViewModel(watchlistStore: WatchlistSymbolStoreSpy(symbols: ["AAPL"]))

        // Then
        #expect(viewModel.addition(for: teslaMatch) == .available)
    }

    @Test func selectSortOrderWhenOrderChangesThenSortsAndTracks() async {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(result: .success([sapQuote, appleQuote]), tracker: tracker)
        await viewModel.refresh()

        // When
        viewModel.selectSortOrder(.symbol)

        // Then
        #expect(viewModel.content.visibleQuotes == [appleQuote, sapQuote])
        #expect(tracker.events(of: WatchlistEvent.self).last == .sortOrderChanged(.symbol))
    }

    @Test func selectSortOrderWhenOrderIsUnchangedThenDoesNotTrack() {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)

        // When
        viewModel.selectSortOrder(viewModel.sortOrder)

        // Then
        #expect(tracker.events(of: WatchlistEvent.self).isEmpty)
    }

    @Test(arguments: [false, true])
    func toggleFavoriteThenFlipsSavesAndTracks(wasFavorite: Bool) {
        // Given
        let favoriteStore = FavoriteSymbolStoreSpy(favoriteSymbols: wasFavorite ? ["AAPL"] : [])
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(favoriteStore: favoriteStore, tracker: tracker)

        // When
        viewModel.toggleFavorite("AAPL")

        // Then
        let expectedEvent = WatchlistEvent.favoriteToggled(symbol: "AAPL", isFavorite: !wasFavorite)
        #expect(viewModel.isFavorite("AAPL") == !wasFavorite)
        #expect(favoriteStore.savedFavoriteSymbols == [viewModel.favoriteSymbols])
        #expect(tracker.events(of: WatchlistEvent.self) == [expectedEvent])
    }

    @Test(arguments: [(false, FavoriteAction.add), (true, .remove)])
    func favoriteActionThenOffersOppositeOfCurrentState(
        isFavorite: Bool,
        expected: FavoriteAction
    ) {
        // Given
        let favoriteStore = FavoriteSymbolStoreSpy(favoriteSymbols: isFavorite ? ["AAPL"] : [])
        let viewModel = makeViewModel(favoriteStore: favoriteStore)

        // When
        let action = viewModel.favoriteAction(for: "AAPL")

        // Then
        #expect(action == expected)
    }

    @Test func openDetailThenTracksAndRoutes() {
        // Given
        let router = WatchlistRouterSpy()
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(router: router, tracker: tracker)

        // When
        viewModel.openDetail(for: sapQuote)

        // Then
        #expect(router.shownSymbols == ["SAP"])
        #expect(tracker.events(of: WatchlistEvent.self) == [.quoteOpened(symbol: "SAP")])
    }

    @Test func trackScreenViewThenTracksScreenViewed() {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)

        // When
        viewModel.trackScreenView()

        // Then
        #expect(tracker.events(of: WatchlistEvent.self) == [.screenViewed])
    }
}

private extension WatchlistViewModelTests {
    func makeViewModel(
        watchlistStore: WatchlistSymbolStoreSpy = .init(),
        result: Result<[StockQuote], MarketDataError> = .success([]),
        searcher: SymbolSearcherSpy = .init(),
        favoriteStore: FavoriteSymbolStoreSpy = .init(),
        clock: ClockSpy = .init(),
        router: WatchlistRouterSpy = .init(),
        tracker: AnalyticsTrackerSpy = .init()
    ) -> WatchlistViewModel {
        .init(
            watchlistStore: watchlistStore,
            quoteProvider: QuoteProviderStub(result: result),
            symbolSearcher: searcher,
            favoriteStore: favoriteStore,
            clock: clock,
            router: router,
            tracker: tracker
        )
    }
}
