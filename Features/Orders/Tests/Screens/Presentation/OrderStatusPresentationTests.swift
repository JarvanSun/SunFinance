//
//  OrderStatusPresentationTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Orders

struct OrderStatusPresentationTests {
    @Test(arguments: [
        (
            OrderStatus.waitingForTrigger,
            "orders.status.waitingForTrigger",
            FinanceImage.scheduled,
            FinanceColor.accent
        ),
        (.waitingForPrice, "orders.status.waitingForPrice", .scheduled, .accent),
        (.scheduled, "orders.status.scheduled", .scheduled, .accent),
        (.waitingForOpen, "orders.status.waitingForOpen", .scheduled, .accent),
        (.filled, "orders.status.filled", .success, .gain),
        (.cancelled, "orders.status.cancelled", .rejected, .textSecondary),
        (.expired, "orders.status.expired", .rejected, .textSecondary),
        (.rejected(.invalidPrice), "orders.status.rejected", .rejected, .critical),
    ])
    func presentationThenFollowsTheStatus(
        status: OrderStatus,
        title: String,
        image: FinanceImage,
        color: FinanceColor
    ) {
        #expect(status.title.key == title)
        #expect(status.image == image)
        #expect(status.color == color)
    }
}
