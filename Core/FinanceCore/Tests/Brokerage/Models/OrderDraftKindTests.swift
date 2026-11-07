//
//  OrderDraftKindTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct OrderDraftKindTests {
    @Test(arguments: [
        (OrderExecution.market, OrderTrigger.immediately, OrderKind.market, OrderTriggerKind.now),
        (.limit(1), .immediately, .limit, .now),
        (.market, .priceAtOrAbove(1), .stop, .price),
        (.market, .priceAtOrBelow(1), .stop, .price),
        (.limit(1), .priceAtOrAbove(1), .stopLimit, .price),
        (.limit(1), .priceAtOrBelow(1), .stopLimit, .price),
        (.market, .at(Date(timeIntervalSince1970: 0)), .market, .time),
        (.limit(1), .at(Date(timeIntervalSince1970: 0)), .limit, .time),
    ])
    func kindThenFollowsExecutionAndTrigger(
        execution: OrderExecution,
        trigger: OrderTrigger,
        kind: OrderKind,
        triggerKind: OrderTriggerKind
    ) {
        // Given
        let draft = OrderDraft(execution: execution, trigger: trigger)

        // Then
        #expect(draft.kind == kind)
        #expect(draft.triggerKind == triggerKind)
    }

    @Test func rawValuesThenAreTheAnalyticsValues() {
        // Then
        #expect(OrderKind.allCases.map(\.rawValue) == ["market", "limit", "stop", "stop_limit"])
        #expect(OrderTriggerKind.allCases.map(\.rawValue) == ["now", "price", "time"])
    }
}
