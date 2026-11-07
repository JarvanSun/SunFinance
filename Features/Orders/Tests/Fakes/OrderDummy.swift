//
//  OrderDummy.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension Order {
    nonisolated static func dummy(
        _ id: String,
        status: OrderStatus = .waitingForPrice,
        amount: OrderAmount = .shares(1),
        side: TradeSide = .buy,
        trigger: OrderTrigger = .immediately,
        createdAt: Date = .init(timeIntervalSince1970: 0),
        fill: OrderFill? = nil
    ) -> Order {
        .init(
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
