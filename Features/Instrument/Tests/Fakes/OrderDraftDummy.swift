//
//  OrderDraftDummy.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension OrderDraft {
    nonisolated static func dummy(
        _ side: TradeSide = .buy,
        amount: OrderAmount = .shares(2),
        execution: OrderExecution = .market,
        trigger: OrderTrigger = .immediately,
        validity: OrderValidity = .day
    ) -> OrderDraft {
        .init(
            symbol: "AAPL",
            side: side,
            amount: amount,
            execution: execution,
            trigger: trigger,
            validity: validity
        )
    }
}
