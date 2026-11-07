//
//  WatchlistDependencies.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore

public struct WatchlistDependencies {
    let watchlistStore: WatchlistSymbolStoring
    let quoteProvider: QuoteProviding
    let symbolSearcher: SymbolSearching
    let favoriteStore: FavoriteSymbolStoring
    let clock: any Clock<Duration>
    let tracker: AnalyticsTracking
    let quoteDetail: FeatureEntry<TickerSymbol>

    public init(
        watchlistStore: WatchlistSymbolStoring,
        quoteProvider: QuoteProviding,
        symbolSearcher: SymbolSearching,
        favoriteStore: FavoriteSymbolStoring,
        clock: some Clock<Duration>,
        tracker: AnalyticsTracking,
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

    func makeViewModel(router: WatchlistRouting) -> WatchlistViewModel {
        .init(
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
