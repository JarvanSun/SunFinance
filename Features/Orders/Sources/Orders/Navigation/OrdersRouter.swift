//
//  OrdersRouter.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Observation
import SunUserInterface

@Observable
final class OrdersRouter: FeatureRouting, OrdersRouting {
    var presentation: FeaturePresentation<OrdersDestination>?
    var path: [OrdersDestination] = []

    private let quoteDetail: FeatureEntry<TickerSymbol>
    @ObservationIgnored var makeDetailViewModel: ((Order) -> OrderDetailViewModel)?

    init(quoteDetail: FeatureEntry<TickerSymbol>) {
        self.quoteDetail = quoteDetail
    }

    func view(for destination: OrdersDestination) -> OrdersDestinationView {
        OrdersDestinationView(
            destination: destination,
            quoteDetail: quoteDetail,
            makeDetailViewModel: makeDetailViewModel
        )
    }

    func showDetail(of order: Order) {
        route(to: OrdersDestination.detail(order))
    }

    func showQuoteDetail(for symbol: TickerSymbol) {
        path.append(.quoteDetail(symbol))
    }
}
