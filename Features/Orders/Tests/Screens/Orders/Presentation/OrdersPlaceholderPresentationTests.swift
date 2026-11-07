//
//  OrdersPlaceholderPresentationTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Orders

struct OrdersPlaceholderPresentationTests {
    @Test(arguments: [
        (
            OrdersPlaceholder.loading,
            "orders.loading",
            "orders.empty.open.message",
            FinanceImage.scheduled
        ),
        (.empty(.open), "orders.empty.open.title", "orders.empty.open.message", .scheduled),
        (.empty(.past), "orders.empty.past.title", "orders.empty.past.message", .scheduled),
        (
            .failed(.offline),
            "orders.failure.offline.title",
            "orders.failure.offline.message",
            .offline
        ),
    ])
    func presentationThenFollowsThePlaceholder(
        placeholder: OrdersPlaceholder,
        title: String,
        message: String,
        image: FinanceImage
    ) {
        // Then
        #expect(placeholder.title.key == title)
        #expect(placeholder.message.key == message)
        #expect(placeholder.image == image)
    }
}
