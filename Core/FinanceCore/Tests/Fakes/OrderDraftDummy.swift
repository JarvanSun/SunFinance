//
//  OrderDraftDummy.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

@testable import FinanceCore

extension OrderDraft {
    nonisolated static func dummy(
        _ side: TradeSide = .buy,
        _ amount: OrderAmount = .shares(1),
        symbol: TickerSymbol = "SAP",
        execution: OrderExecution = .market,
        trigger: OrderTrigger = .immediately,
        validity: OrderValidity = .day
    ) -> OrderDraft {
        .init(
            symbol: symbol,
            side: side,
            amount: amount,
            execution: execution,
            trigger: trigger,
            validity: validity
        )
    }
}
