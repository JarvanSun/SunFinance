//
//  PlaygroundDependencies.swift
//  WatchlistPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import SwiftUI
import Watchlist

struct PlaygroundDependencies {
    private let marketData = MarketDataService(
        environment: .init(mockBehavior: .realistic, storageDirectory: nil)
    )
    private let watchlistStore = InMemoryWatchlistSymbolStore(symbols: TickerSymbol.dummyWatchlist)
    private let favoriteStore = InMemoryFavoriteSymbolStore(
        favoriteSymbols: TickerSymbol.dummyFavorites
    )
    private let tracker = AnalyticsTracker(playgroundSubsystem: "WatchlistPlayground")

    func watchlist() -> WatchlistDependencies {
        .init(
            watchlistStore: watchlistStore,
            quoteProvider: marketData,
            symbolSearcher: marketData,
            favoriteStore: favoriteStore,
            clock: ContinuousClock(),
            tracker: tracker,
            quoteDetail: .init { StandInScreen(title: "Quote detail \($0.rawValue)") }
        )
    }
}

private extension AnalyticsTracker {
    convenience init(playgroundSubsystem subsystem: String) {
        let consent = UserDefaultsAnalyticsConsent(defaults: .standard)
        consent.setConsent(true)
        self.init(
            consent: consent,
            context: .init(appVersion: "playground", locale: .autoupdatingCurrent),
            destinations: [ConsoleAnalyticsDestination(subsystem: subsystem)]
        )
    }
}
