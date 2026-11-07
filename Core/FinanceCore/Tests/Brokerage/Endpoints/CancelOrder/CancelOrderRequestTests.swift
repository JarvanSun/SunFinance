//
//  CancelOrderRequestTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore
import Testing

@testable import FinanceCore

struct CancelOrderRequestTests {
    @Test func requestThenDeletesTheOrder() {
        // Given
        let request = CancelOrderRequest(orderID: "order-1")

        // Then
        #expect(request.path == ["v1", "orders", "order-1"])
        #expect(request.method == .delete)
        #expect(request.body == nil)
    }
}
