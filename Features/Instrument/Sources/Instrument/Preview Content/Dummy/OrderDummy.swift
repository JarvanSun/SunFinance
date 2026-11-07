//
//  OrderDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension Order {
    nonisolated static func dummy(_ draft: OrderDraft, status: OrderStatus) -> Order {
        let fill = OrderFill(
            date: Date(timeIntervalSince1970: 1_793_718_000),
            quantity: 2,
            price: Money(231.42, .usd),
            exchangeRate: 0.9213,
            fee: Money(1, .eur),
            total: Money(427.42, .eur)
        )
        return .init(
            id: "preview",
            draft: draft,
            quantity: 2,
            currency: .usd,
            status: status,
            createdAt: fill.date,
            fill: status == .filled ? fill : nil
        )
    }

    nonisolated static var dummyOpen: Order {
        .init(
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
            createdAt: Date(timeIntervalSince1970: 1_793_000_000),
            fill: nil
        )
    }

    nonisolated static var dummyPast: Order {
        let filledAt = Date(timeIntervalSince1970: 1_793_000_000).addingTimeInterval(9_000)
        return .init(
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
            createdAt: filledAt,
            fill: OrderFill(
                date: filledAt,
                quantity: 5,
                price: Money(228.6, .usd),
                exchangeRate: 0.92,
                fee: Money(1, .eur),
                total: Money(1_052.56, .eur)
            )
        )
    }
}
#endif
