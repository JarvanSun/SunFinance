//
//  OrderDraftDummy.swift
//  OrdersPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension OrderDraft {
    static var dummyOpenOrders: [OrderDraft] {
        [
            OrderDraft(
                symbol: "AAPL",
                side: .buy,
                amount: .shares(3),
                execution: .limit(1),
                trigger: .immediately,
                validity: .goodTillCancelled
            ),
            OrderDraft(
                symbol: "SAP",
                side: .sell,
                amount: .shares(5),
                execution: .market,
                trigger: .priceAtOrBelow(1),
                validity: .goodTillCancelled
            ),
            OrderDraft(
                symbol: "NVDA",
                side: .buy,
                amount: .euros(500),
                execution: .market,
                trigger: .at(.now.addingTimeInterval(86_400)),
                validity: .day
            ),
        ]
    }
}
