//
//  PreviewBrokerage.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

struct PreviewBrokerage: PositionProviding, OrderProviding {
    let isHolding: Bool

    func portfolio() async throws(BrokerageError) -> Portfolio {
        guard isHolding else { return Portfolio(open: [], closed: []) }

        return Portfolio(open: [PreviewObjectPool.position], closed: [])
    }

    func orders(
        _ filter: OrderListFilter,
        symbol: TickerSymbol?,
        cursor: String?
    ) async throws(BrokerageError) -> Page<Order> {
        let start = Date(timeIntervalSince1970: 1_793_000_000)
        let order: Order =
            switch filter {
            case .open:
                Order(
                    id: "open",
                    draft: OrderDraft(
                        symbol: "AAPL",
                        side: .buy,
                        amount: .shares(2),
                        execution: .limit(229),
                        trigger: .immediately,
                        validity: .goodTillCancelled
                    ),
                    quantity: 2,
                    currency: .usd,
                    status: .waitingForPrice,
                    createdAt: start,
                    fill: nil
                )
            case .past:
                Order(
                    id: "past",
                    draft: OrderDraft(
                        symbol: "AAPL",
                        side: .buy,
                        amount: .shares(5),
                        execution: .market,
                        trigger: .immediately,
                        validity: .day
                    ),
                    quantity: 5,
                    currency: .usd,
                    status: .filled,
                    createdAt: start.addingTimeInterval(9_000),
                    fill: OrderFill(
                        date: start.addingTimeInterval(9_000),
                        quantity: 5,
                        price: Money(228.6, .usd),
                        exchangeRate: 0.92,
                        fee: Money(1, .eur),
                        total: Money(1_052.56, .eur)
                    )
                )
            }
        return Page(elements: isHolding ? [order] : [], nextCursor: nil)
    }
}
#endif
