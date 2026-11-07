//
//  WatchlistDependenciesTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SwiftUI
import Testing

@testable import Watchlist

struct WatchlistDependenciesTests {
    @Test func makeViewModelThenUsesInjectedWatchlistAndFavorites() {
        // Given
        let dependencies = WatchlistDependencies(
            watchlistStore: WatchlistSymbolStoreSpy(symbols: ["AAPL"]),
            quoteProvider: QuoteProviderStub(result: .success([])),
            symbolSearcher: SymbolSearcherSpy(),
            favoriteStore: FavoriteSymbolStoreSpy(favoriteSymbols: ["AAPL"]),
            clock: ClockSpy(),
            tracker: AnalyticsTrackerSpy(),
            quoteDetail: FeatureEntry { _ in EmptyView() }
        )

        // When
        let viewModel = dependencies.makeViewModel(router: WatchlistRouterSpy())

        // Then
        #expect(viewModel.symbols == ["AAPL"])
        #expect(viewModel.isFavorite("AAPL"))
    }
}
