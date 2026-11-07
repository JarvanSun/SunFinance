//
//  OrdersIssueTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Orders

struct OrdersIssueTests {
    @Test(arguments: [
        (BrokerageError.offline, OrdersIssue.offline),
        (.server(statusCode: 503), .serviceUnavailable),
        (.decoding, .serviceUnavailable),
        (.cancelled, .serviceUnavailable),
    ])
    func initThenNamesTheIssue(error: BrokerageError, expected: OrdersIssue) {
        #expect(OrdersIssue(error) == expected)
    }
}
