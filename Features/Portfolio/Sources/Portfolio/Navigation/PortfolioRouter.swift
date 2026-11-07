//
//  PortfolioRouter.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Observation
import SunUserInterface

@Observable
final class PortfolioRouter: FeatureRouting, PortfolioRouting {
    var presentation: FeaturePresentation<PortfolioDestination>?
    var path: [PortfolioDestination] = []

    private let quoteDetail: FeatureEntry<TickerSymbol>
    private let orderTicket: FeatureEntry<TradeIntent>

    init(quoteDetail: FeatureEntry<TickerSymbol>, orderTicket: FeatureEntry<TradeIntent>) {
        self.quoteDetail = quoteDetail
        self.orderTicket = orderTicket
    }

    func view(for destination: PortfolioDestination) -> PortfolioDestinationView {
        .init(
            destination: destination,
            quoteDetail: quoteDetail,
            orderTicket: orderTicket
        )
    }

    func showQuoteDetail(for symbol: TickerSymbol) {
        route(to: PortfolioDestination.quoteDetail(symbol))
    }

    func showOrderTicket(for intent: TradeIntent) {
        route(to: PortfolioDestination.orderTicket(intent))
    }
}
