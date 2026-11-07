//
//  WatchlistRouter.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Observation
import SunUserInterface

@Observable
final class WatchlistRouter: FeatureRouting, WatchlistRouting {
    var presentation: FeaturePresentation<WatchlistDestination>?
    var path: [WatchlistDestination] = []

    private let quoteDetail: FeatureEntry<TickerSymbol>

    init(quoteDetail: FeatureEntry<TickerSymbol>) {
        self.quoteDetail = quoteDetail
    }

    func view(for destination: WatchlistDestination) -> WatchlistDestinationView {
        WatchlistDestinationView(destination: destination, quoteDetail: quoteDetail)
    }

    func showQuoteDetail(for symbol: TickerSymbol) {
        route(to: WatchlistDestination.quoteDetail(symbol))
    }
}
