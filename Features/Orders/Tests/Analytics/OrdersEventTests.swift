//
//  OrdersEventTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Orders

struct OrdersEventTests {
    @Test func cancelledThenDescribesTypeAndTriggerOnly() {
        // When
        let event = OrdersEvent.cancelled(Order.make("1").draft)

        // Then
        #expect(event.name == .tradingOrderCancelled)
        #expect(event.parameters == [.orderType: .text("limit"), .trigger: .text("now")])
    }
}
