//
//  OrderDummy.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension Order {
    nonisolated static var dummyList: [Order] {
        let start = Date(timeIntervalSince1970: 1_793_718_000)
        let fill = OrderFill(
            date: start,
            quantity: 2,
            price: Money(231.42, .usd),
            exchangeRate: 0.9213,
            fee: Money(1, .eur),
            total: Money(427.42, .eur)
        )
        return [
            Order(
                id: "1",
                draft: OrderDraft(
                    symbol: "AAPL",
                    side: .buy,
                    amount: .shares(5),
                    execution: .limit(210),
                    trigger: .immediately,
                    validity: .goodTillCancelled
                ),
                quantity: 5,
                currency: .usd,
                status: .waitingForPrice,
                createdAt: start,
                fill: nil
            ),
            Order(
                id: "2",
                draft: OrderDraft(
                    symbol: "SAP",
                    side: .sell,
                    amount: .shares(5),
                    execution: .market,
                    trigger: .priceAtOrBelow(200),
                    validity: .day
                ),
                quantity: 5,
                currency: .eur,
                status: .waitingForTrigger,
                createdAt: start.addingTimeInterval(-3_600),
                fill: nil
            ),
            Order(
                id: "3",
                draft: OrderDraft(
                    symbol: "AAPL",
                    side: .buy,
                    amount: .shares(2),
                    execution: .market,
                    trigger: .immediately,
                    validity: .day
                ),
                quantity: 2,
                currency: .usd,
                status: .filled,
                createdAt: start.addingTimeInterval(-86_400),
                fill: fill
            ),
            Order(
                id: "4",
                draft: OrderDraft(
                    symbol: "NVDA",
                    side: .buy,
                    amount: .euros(50_000),
                    execution: .market,
                    trigger: .immediately,
                    validity: .day
                ),
                quantity: 300,
                currency: .usd,
                status: .rejected(.insufficientCash),
                createdAt: start.addingTimeInterval(-2 * 86_400),
                fill: nil
            ),
        ]
    }
}
#endif
