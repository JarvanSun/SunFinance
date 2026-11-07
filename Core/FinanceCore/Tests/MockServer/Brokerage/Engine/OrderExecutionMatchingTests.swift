//
//  OrderExecutionMatchingTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct OrderExecutionMatchingTests {
    @Test(arguments: [
        (OrderExecution.market, TradeSide.buy, Decimal(500), true),
        (.market, .sell, 1, true),
        (.limit(100), .buy, 99, true),
        (.limit(100), .buy, 101, false),
        (.limit(100), .sell, 101, true),
        (.limit(100), .sell, 99, false),
        (.limit(100), .sell, 100, true),
    ])
    func allowsFillThenAcceptsOnlyPricesAtOrBetterThanTheLimit(
        execution: OrderExecution,
        side: TradeSide,
        price: Decimal,
        expected: Bool
    ) {
        // Then
        #expect(execution.allowsFill(at: price, side: side) == expected)
    }
}
