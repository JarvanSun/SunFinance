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
            watchlistStore: WatchlistSymbolStoreSpy(symbols: [.apple]),
            quoteProvider: QuoteProviderStub(result: .success([])),
            symbolSearcher: SymbolSearcherSpy(),
            favoriteStore: FavoriteSymbolStoreSpy(favoriteSymbols: [.apple]),
            clock: ClockSpy(),
            tracker: AnalyticsTrackerSpy(),
            quoteDetail: FeatureEntry { _ in EmptyView() }
        )

        // When
        let viewModel = dependencies.makeViewModel(router: WatchlistRouterSpy())

        // Then
        #expect(viewModel.symbols == [.apple])
        #expect(viewModel.isFavorite(.apple))
    }
}
