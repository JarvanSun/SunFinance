//
//  BrokerageCall.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

enum BrokerageCall: String, CaseIterable, Identifiable, Sendable {
    case account
    case portfolio
    case history
    case openOrders
    case pastOrders
    case previewBuy
    case placeBuy
    case placeLimit

    var id: Self { self }

    var title: String {
        switch self {
        case .account:
            "Account"
        case .portfolio:
            "Positions"
        case .history:
            "Portfolio history, 1M"
        case .openOrders:
            "Open orders"
        case .pastOrders:
            "Past orders"
        case .previewBuy:
            "Preview: buy 2 AAPL"
        case .placeBuy:
            "Place: buy 1 SAP at market"
        case .placeLimit:
            "Place: buy 1 NVDA, limit 1 USD"
        }
    }

    func run(on service: BrokerageService) async throws(BrokerageError) -> String {
        switch self {
        case .account:
            return String(describing: try await service.account())
        case .portfolio:
            let portfolio = try await service.portfolio()
            return (portfolio.open + portfolio.closed).map(describe).joined(separator: "\n\n")
        case .history:
            let history = try await service.portfolioHistory(range: .month)
            return "\(history.points.count) points, last \(String(describing: history.points.last))"
        case .openOrders:
            return try await service.orders(.open, symbol: nil, cursor: nil).elements.map {
                String(describing: $0)
            }.joined(separator: "\n\n")
        case .pastOrders:
            return try await service.orders(.past, symbol: nil, cursor: nil).elements.map {
                String(describing: $0)
            }.joined(separator: "\n\n")
        case .previewBuy:
            return String(describing: try await service.preview(draft("AAPL", shares: 2)))
        case .placeBuy:
            return String(
                describing: try await service.place(
                    draft("SAP", shares: 1),
                    idempotencyKey: IdempotencyKey()
                )
            )
        case .placeLimit:
            return String(
                describing: try await service.place(
                    draft("NVDA", shares: 1, execution: .limit(1)),
                    idempotencyKey: IdempotencyKey()
                )
            )
        }
    }
}

private extension BrokerageCall {
    func draft(_ symbol: TickerSymbol, shares: Int, execution: OrderExecution = .market)
        -> OrderDraft
    {
        OrderDraft(
            symbol: symbol,
            side: .buy,
            amount: .shares(Decimal(shares)),
            execution: execution,
            trigger: .immediately,
            validity: .day
        )
    }

    func describe(_ position: Position) -> String {
        """
        \(position.symbol.rawValue) × \(position.quantity)
        value \(position.marketValue.amount) EUR, cost \(position.costBasis.amount) EUR
        unrealized \(position.unrealizedGain.amount) EUR, realized \(position.realizedGain.amount) EUR
        today \(position.todayGain.amount) EUR, currency effect \(position.currencyEffect.amount) EUR
        """
    }
}
