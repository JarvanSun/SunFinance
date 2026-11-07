//
//  OrderFixtures.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension Order {
    nonisolated static func make(
        _ id: String,
        status: OrderStatus = .waitingForPrice,
        amount: OrderAmount = .shares(1),
        side: TradeSide = .buy,
        trigger: OrderTrigger = .immediately,
        createdAt: Date = Date(timeIntervalSince1970: 0),
        fill: OrderFill? = nil
    ) -> Order {
        Order(
            id: id,
            draft: OrderDraft(
                symbol: "SAP",
                side: side,
                amount: amount,
                execution: .limit(100),
                trigger: trigger,
                validity: .goodTillCancelled
            ),
            quantity: 1,
            currency: .eur,
            status: status,
            createdAt: createdAt,
            fill: fill
        )
    }
}

extension OrderFill {
    nonisolated static func make(currency: CurrencyCode) -> OrderFill {
        OrderFill(
            date: Date(timeIntervalSince1970: 0),
            quantity: 1,
            price: Money(100, currency),
            exchangeRate: Decimal(string: "0.92")!,
            fee: Money(1, .eur),
            total: Money(93, .eur)
        )
    }
}
