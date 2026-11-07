//
//  OrderDraftDummy.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension OrderDraft {
    static func dummyBuy(
        _ symbol: TickerSymbol,
        shares: Int,
        execution: OrderExecution = .market
    ) -> OrderDraft {
        .init(
            symbol: symbol,
            side: .buy,
            amount: .shares(Decimal(shares)),
            execution: execution,
            trigger: .immediately,
            validity: .day
        )
    }
}
