//
//  OrdersIssuePresentationTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

@testable import Orders

struct OrdersIssuePresentationTests {
    @Test(arguments: [
        (OrdersIssue.offline, "offline", FinanceImage.offline),
        (.serviceUnavailable, "service", .warning),
    ])
    func presentationThenNamesTheIssue(issue: OrdersIssue, name: String, image: FinanceImage) {
        // Then
        #expect(issue.title.key == "orders.failure.\(name).title")
        #expect(issue.message.key == "orders.failure.\(name).message")
        #expect(issue.image == image)
    }
}
