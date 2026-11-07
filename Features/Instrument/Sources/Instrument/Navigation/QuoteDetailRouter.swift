//
//  QuoteDetailRouter.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Observation
import SunUserInterface

@Observable
final class QuoteDetailRouter: FeatureRouting, QuoteDetailRouting {
    var presentation: FeaturePresentation<QuoteDetailDestination>? {
        didSet { notifyDismissal(after: oldValue) }
    }
    var path: [QuoteDetailDestination] = []

    private let orderTicket: (TradeIntent) -> TradingDependencies

    @ObservationIgnored private var onTicketDismiss: (() -> Void)?

    init(orderTicket: @escaping (TradeIntent) -> TradingDependencies) {
        self.orderTicket = orderTicket
    }

    func view(for destination: QuoteDetailDestination) -> QuoteDetailDestinationView {
        .init(destination: destination, orderTicket: orderTicket)
    }

    func showOrderTicket(for intent: TradeIntent, onDismiss: @escaping () -> Void) {
        onTicketDismiss = onDismiss
        route(to: QuoteDetailDestination.orderTicket(intent))
    }
}

private extension QuoteDetailRouter {
    func notifyDismissal(after previous: FeaturePresentation<QuoteDetailDestination>?) {
        guard previous != nil, presentation == nil else { return }

        let onDismiss = onTicketDismiss
        onTicketDismiss = nil
        onDismiss?()
    }
}
