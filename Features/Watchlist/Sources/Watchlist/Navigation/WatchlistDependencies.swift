//
//  WatchlistDependencies.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore

public struct WatchlistDependencies {
    let watchlistStore: any WatchlistSymbolStoring
    let quoteProvider: any QuoteProviding
    let symbolSearcher: any SymbolSearching
    let favoriteStore: any FavoriteSymbolStoring
    let clock: any Clock<Duration>
    let tracker: any AnalyticsTracking
    let quoteDetail: FeatureEntry<TickerSymbol>

    public init(
        watchlistStore: some WatchlistSymbolStoring,
        quoteProvider: some QuoteProviding,
        symbolSearcher: some SymbolSearching,
        favoriteStore: some FavoriteSymbolStoring,
        clock: some Clock<Duration>,
        tracker: some AnalyticsTracking,
        quoteDetail: FeatureEntry<TickerSymbol>
    ) {
        self.watchlistStore = watchlistStore
        self.quoteProvider = quoteProvider
        self.symbolSearcher = symbolSearcher
        self.favoriteStore = favoriteStore
        self.clock = clock
        self.tracker = tracker
        self.quoteDetail = quoteDetail
    }

    func makeViewModel(router: some WatchlistRouting) -> WatchlistViewModel {
        WatchlistViewModel(
            watchlistStore: watchlistStore,
            quoteProvider: quoteProvider,
            symbolSearcher: symbolSearcher,
            favoriteStore: favoriteStore,
            clock: clock,
            router: router,
            tracker: tracker
        )
    }
}
