//
//  OrderDummy.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension Order {
    nonisolated static func dummy(
        _ draft: OrderDraft = .dummy(),
        status: OrderStatus
    ) -> Order {
        let fill = OrderFill(
            date: .dummyNow,
            quantity: 2,
            price: Money(200, .usd),
            exchangeRate: 1,
            fee: Money(1, .eur),
            total: Money(401, .eur)
        )
        return .init(
            id: "order-1",
            draft: draft,
            quantity: 2,
            currency: .usd,
            status: status,
            createdAt: .dummyNow,
            fill: status == .filled ? fill : nil
        )
    }

    nonisolated static func dummy(
        _ symbol: TickerSymbol,
        side: TradeSide = .buy,
        execution: OrderExecution = .market,
        trigger: OrderTrigger = .immediately,
        status: OrderStatus,
        fillDate: Date? = nil
    ) -> Order {
        .init(
            id: UUID().uuidString,
            draft: OrderDraft(
                symbol: symbol,
                side: side,
                amount: .shares(1),
                execution: execution,
                trigger: trigger,
                validity: .day
            ),
            quantity: 1,
            currency: .usd,
            status: status,
            createdAt: Date(timeIntervalSince1970: 0),
            fill: fillDate.map {
                OrderFill(
                    date: $0,
                    quantity: 1,
                    price: Money(105, .usd),
                    exchangeRate: 1,
                    fee: Money(1, .eur),
                    total: Money(106, .eur)
                )
            }
        )
    }

    nonisolated var withoutFill: Order {
        .init(
            id: id,
            draft: draft,
            quantity: quantity,
            currency: currency,
            status: status,
            createdAt: createdAt,
            fill: nil
        )
    }
}
