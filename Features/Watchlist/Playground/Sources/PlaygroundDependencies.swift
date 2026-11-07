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
        environment: .mock(behavior: .realistic, storageDirectory: nil)
    )
    private let watchlistStore = InMemoryWatchlistSymbolStore(symbols: ["AAPL", "SAP"])
    private let favoriteStore = InMemoryFavoriteSymbolStore(favoriteSymbols: ["AAPL"])
    private let tracker = PlaygroundDependencies.makeTracker()

    func watchlist() -> WatchlistDependencies {
        WatchlistDependencies(
            watchlistStore: watchlistStore,
            quoteProvider: marketData,
            symbolSearcher: marketData,
            favoriteStore: favoriteStore,
            clock: ContinuousClock(),
            tracker: tracker,
            quoteDetail: FeatureEntry { StandInScreen(title: "Quote detail \($0.rawValue)") }
        )
    }
}

private extension PlaygroundDependencies {
    static func makeTracker() -> AnalyticsTracker {
        let consent = UserDefaultsAnalyticsConsent(defaults: .standard)
        consent.setConsent(true)
        return AnalyticsTracker(
            consent: consent,
            context: AnalyticsContext(appVersion: "playground", locale: .autoupdatingCurrent),
            destinations: [ConsoleAnalyticsDestination(subsystem: "WatchlistPlayground")]
        )
    }
}
