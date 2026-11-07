//
//  PreviewObjectPool.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import DesignSystem
import FinanceCore
import Foundation
import SwiftUI

struct PreviewObjectPool {
    func watchlistDependencies() -> WatchlistDependencies {
        .init(
            watchlistStore: InMemoryWatchlistSymbolStore(
                symbols: StockQuote.dummyWatchlist.map(\.symbol)
            ),
            quoteProvider: PreviewQuoteProvider(
                result: .success(StockQuote.dummyWatchlist),
                delay: .zero
            ),
            symbolSearcher: PreviewSymbolSearcher(result: .success(SymbolMatch.dummySearchResults)),
            favoriteStore: InMemoryFavoriteSymbolStore(
                favoriteSymbols: TickerSymbol.dummyFavorites
            ),
            clock: ContinuousClock(),
            tracker: PreviewAnalyticsTracker(),
            quoteDetail: FeatureEntry { symbol in
                PreviewStandInScreen(title: "Quote detail \(symbol.rawValue)")
            }
        )
    }

    func watchlistViewModel(_ state: WatchlistPreviewState) -> WatchlistViewModel {
        let viewModel = WatchlistViewModel(
            watchlistStore: InMemoryWatchlistSymbolStore(
                symbols: StockQuote.dummyWatchlist.map(\.symbol)
            ),
            quoteProvider: PreviewQuoteProvider(result: state.result, delay: state.delay),
            symbolSearcher: PreviewSymbolSearcher(result: state.searchResult),
            favoriteStore: InMemoryFavoriteSymbolStore(
                favoriteSymbols: TickerSymbol.dummyFavorites
            ),
            clock: ContinuousClock(),
            router: PreviewWatchlistRouter(),
            tracker: PreviewAnalyticsTracker()
        )
        viewModel.searchText = state.searchText
        return viewModel
    }
}
#endif
