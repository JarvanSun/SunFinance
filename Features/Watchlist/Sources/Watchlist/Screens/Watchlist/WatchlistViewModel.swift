//
//  WatchlistViewModel.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Observation

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

    var content: WatchlistContent {
        .init(
            quotes: quotes,
            symbolMatches: symbolMatches,
            searchText: searchText,
            sortOrder: sortOrder
        )
    }

    var searchRequest: SymbolSearchRequest {
        .init(query: searchText, attempt: searchAttempt)
    }

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
    ) {
        self.watchlistStore = watchlistStore
        self.quoteProvider = quoteProvider
        self.symbolSearcher = symbolSearcher
        self.favoriteStore = favoriteStore
        self.clock = clock
        self.router = router
        self.tracker = tracker
        symbols = watchlistStore.symbols
        favoriteSymbols = favoriteStore.favoriteSymbols
    }

    func trackScreenView() {
        tracker.track(WatchlistEvent.screenViewed)
    }

    func refresh() async {
        activity = .loading
        let result = await loadQuotes()
        guard !Task.isCancelled else { return }

        apply(result)
    }

    func retry() {
        quotesRequest = UUID()
        searchAttempt = UUID()
    }

    func searchSymbols() async {
        let query = trimmedSearchText
        guard !query.isEmpty else { return clearSymbolMatches() }

        searchActivity = .loading
        await waitForTypingToPause()
        guard !Task.isCancelled else { return }

        let result = await findSymbols(matching: query)
        guard !Task.isCancelled else { return }

        apply(result, for: query)
    }

    func submitSearch() {
        guard isSearching else { return }

        tracker.track(WatchlistEvent.searchSubmitted(resultCount: content.resultCount))
    }

    func selectSortOrder(_ order: WatchlistSortOrder) {
        guard order != sortOrder else { return }

        sortOrder = order
        tracker.track(WatchlistEvent.sortOrderChanged(order))
    }

    func toggleFavorite(_ symbol: TickerSymbol) {
        let isFavorite = favoriteSymbols.toggle(symbol)
        favoriteStore.save(favoriteSymbols)
        tracker.track(WatchlistEvent.favoriteToggled(symbol: symbol, isFavorite: isFavorite))
    }

    func addToWatchlist(_ match: SymbolMatch) {
        guard !symbols.contains(match.symbol) else { return }

        symbols.append(match.symbol)
        watchlistStore.save(symbols)
        quotesRequest = UUID()
        tracker.track(WatchlistEvent.symbolAdded(symbol: match.symbol))
    }

    func openDetail(for quote: StockQuote) {
        tracker.track(WatchlistEvent.quoteOpened(symbol: quote.symbol))
        router.showQuoteDetail(for: quote.symbol)
    }

    func isFavorite(_ symbol: TickerSymbol) -> Bool {
        favoriteSymbols.contains(symbol)
    }

    func favoriteAction(for symbol: TickerSymbol) -> FavoriteAction {
        isFavorite(symbol) ? .remove : .add
    }

    func addition(for match: SymbolMatch) -> SymbolAddition {
        symbols.contains(match.symbol) ? .added : .available
    }
}

// MARK: - Private

private extension WatchlistViewModel {
    typealias QuoteResult = Result<[StockQuote], MarketDataError>
    typealias MatchResult = Result<[SymbolMatch], MarketDataError>

    var searchDelay: Duration { .milliseconds(300) }

    var isSearching: Bool {
        !searchText.isBlank
    }

    var trimmedSearchText: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var hasSearchedCurrentQuery: Bool {
        isSearching && searchedQuery == trimmedSearchText
    }

    func loadQuotes() async -> QuoteResult {
        do {
            return .success(try await quoteProvider.quotes(for: symbols))
        } catch {
            return .failure(error)
        }
    }

    func apply(_ result: QuoteResult) {
        switch result {
        case .success(let fetchedQuotes):
            show(fetchedQuotes)
        case .failure(let error):
            show(WatchlistIssue(error))
        }
    }

    func show(_ fetchedQuotes: [StockQuote]) {
        quotes = fetchedQuotes
        activity = .loaded
        tracker.track(WatchlistEvent.quotesLoaded(count: fetchedQuotes.count))
    }

    func show(_ issue: WatchlistIssue) {
        activity = .failed(issue)
        tracker.track(WatchlistEvent.quotesFailed(issue))
    }

    func clearSymbolMatches() {
        symbolMatches = []
        searchedQuery = ""
        searchActivity = .idle
    }

    func waitForTypingToPause() async {
        try? await clock.sleep(for: searchDelay)
    }

    func findSymbols(matching query: String) async -> MatchResult {
        do {
            return .success(try await symbolSearcher.symbols(matching: query))
        } catch {
            return .failure(error)
        }
    }

    func apply(_ result: MatchResult, for query: String) {
        searchedQuery = query
        switch result {
        case .success(let matches):
            symbolMatches = matches
            searchActivity = .loaded
        case .failure(let error):
            symbolMatches = []
            searchActivity = .failed(WatchlistIssue(error))
        }
    }
}
