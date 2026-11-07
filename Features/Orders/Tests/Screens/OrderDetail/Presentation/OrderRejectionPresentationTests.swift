//
//  OrderRejectionPresentationTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Orders

struct OrderRejectionPresentationTests {
    @Test(arguments: OrderRejection.allCases)
    func messageThenHasOneKeyPerReason(rejection: OrderRejection) {
        // Then
        #expect(rejection.message.key.hasPrefix("orders.rejection."))
        let keys = Set(OrderRejection.allCases.map(\.message.key))
        #expect(keys.count == OrderRejection.allCases.count)
    }
}
