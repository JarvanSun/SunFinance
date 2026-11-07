//
//  OrderStatusNotePresentationTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Orders

struct OrderStatusNotePresentationTests {
    @Test(arguments: [
        (OrderStatus.waitingForTrigger, "orders.status.detail.waitingForTrigger"),
        (.waitingForPrice, "orders.status.detail.waitingForPrice"),
        (.scheduled, "orders.status.detail.scheduled"),
        (.waitingForOpen, "orders.status.detail.waitingForOpen"),
    ])
    func initWhenOpenThenSaysWhatTheOrderWaitsFor(status: OrderStatus, key: String) {
        // Then
        #expect(OrderStatusNote(status).waitingKey == key)
    }

    @Test func initWhenRejectedThenGivesTheReason() {
        // Then
        #expect(
            OrderStatusNote(.rejected(.insufficientCash))
                == .rejected(OrderRejection.insufficientCash.message)
        )
    }

    @Test(arguments: [OrderStatus.filled, .cancelled, .expired])
    func initWhenPastThenHasNone(status: OrderStatus) {
        // Then
        #expect(OrderStatusNote(status) == .none)
    }
}

private extension OrderStatusNote {
    var waitingKey: String? {
        switch self {
        case .waiting(let text):
            text.key
        case .none, .rejected:
            nil
        }
    }
}
