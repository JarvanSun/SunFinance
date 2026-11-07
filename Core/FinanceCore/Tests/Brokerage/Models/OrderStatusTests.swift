//
//  OrderStatusTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct OrderStatusTests {
    @Test(arguments: [
        ("waiting_for_trigger", String?.none, OrderStatus?.some(.waitingForTrigger)),
        ("waiting_for_price", nil, .waitingForPrice),
        ("scheduled", nil, .scheduled),
        ("waiting_for_open", nil, .waitingForOpen),
        ("filled", nil, .filled),
        ("cancelled", nil, .cancelled),
        ("expired", nil, .expired),
        ("rejected", "invalid_price", .rejected(.invalidPrice)),
        ("rejected", nil, nil),
        ("rejected", "too_late", nil),
        ("parked", nil, nil),
    ])
    func initWithCodeThenMapsEveryStatus(code: String, rejection: String?, expected: OrderStatus?) {
        // When
        let status = OrderStatus(code: code, rejection: rejection)

        // Then
        #expect(status == expected)
    }

    @Test(arguments: [
        (OrderStatus.waitingForTrigger, true),
        (.waitingForPrice, true),
        (.scheduled, true),
        (.waitingForOpen, true),
        (.filled, false),
        (.cancelled, false),
        (.expired, false),
        (.rejected(.insufficientCash), false),
    ])
    func isOpenThenIsTrueOnlyWhileWaiting(status: OrderStatus, isOpen: Bool) {
        // Then
        #expect(status.isOpen == isOpen)
    }
}
