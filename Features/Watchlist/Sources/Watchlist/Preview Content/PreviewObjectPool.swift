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

enum PreviewObjectPool {
    static func watchlistDependencies() -> WatchlistDependencies {
        WatchlistDependencies(
            watchlistStore: InMemoryWatchlistSymbolStore(symbols: quotes.map(\.symbol)),
            quoteProvider: PreviewQuoteProvider(result: .success(quotes), delay: .zero),
            symbolSearcher: PreviewSymbolSearcher(result: .success(symbolMatches)),
            favoriteStore: InMemoryFavoriteSymbolStore(favoriteSymbols: ["AAPL"]),
            clock: ContinuousClock(),
            tracker: PreviewAnalyticsTracker(),
            quoteDetail: FeatureEntry { symbol in
                PreviewStandInScreen(title: "Quote detail \(symbol.rawValue)")
            }
        )
    }

    static func watchlistViewModel(_ state: WatchlistPreviewState) -> WatchlistViewModel {
        let viewModel = WatchlistViewModel(
            watchlistStore: InMemoryWatchlistSymbolStore(symbols: quotes.map(\.symbol)),
            quoteProvider: PreviewQuoteProvider(result: state.result, delay: state.delay),
            symbolSearcher: PreviewSymbolSearcher(result: state.searchResult),
            favoriteStore: InMemoryFavoriteSymbolStore(favoriteSymbols: ["AAPL"]),
            clock: ContinuousClock(),
            router: PreviewWatchlistRouter(),
            tracker: PreviewAnalyticsTracker()
        )
        viewModel.searchText = state.searchText
        return viewModel
    }

    static var gainingQuote: StockQuote {
        .init(
            symbol: "AAPL",
            companyName: "Apple Inc.",
            price: Money(228.52, .usd),
            changePercent: 1.24,
            marketCap: Money(3_450_000_000_000, .usd)
        )
    }

    static var losingQuote: StockQuote {
        .init(
            symbol: "SAP",
            companyName: "SAP SE",
            price: Money(221.35, .eur),
            changePercent: -0.38,
            marketCap: Money(271_000_000_000, .eur)
        )
    }

    static var unchangedQuote: StockQuote {
        .init(
            symbol: "ALV",
            companyName: "Allianz SE",
            price: Money(289.90, .eur),
            changePercent: 0,
            marketCap: Money(113_000_000_000, .eur)
        )
    }

    static var quotes: [StockQuote] {
        [gainingQuote, losingQuote, unchangedQuote]
    }

    static var teslaMatch: SymbolMatch {
        .init(symbol: "TSLA", companyName: "Tesla, Inc.", exchange: "NASDAQ", currency: .usd)
    }

    static var siemensMatch: SymbolMatch {
        .init(symbol: "SIE", companyName: "Siemens AG", exchange: "XETRA", currency: .eur)
    }

    static var symbolMatches: [SymbolMatch] {
        [teslaMatch, siemensMatch]
    }
}
#endif
