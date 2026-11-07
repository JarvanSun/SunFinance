//
//  OrderDraftDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension OrderDraft {
    nonisolated static var dummyMarket: OrderDraft {
        .init(
            symbol: "AAPL",
            side: .buy,
            amount: .shares(2),
            execution: .market,
            trigger: .immediately,
            validity: .day
        )
    }

    static var dummyLimit: OrderDraft {
        .init(
            symbol: "AAPL",
            side: .buy,
            amount: .shares(2),
            execution: .limit(235),
            trigger: .immediately,
            validity: .goodTillCancelled
        )
    }
}
#endif
