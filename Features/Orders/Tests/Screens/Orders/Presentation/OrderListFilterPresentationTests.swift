//
//  OrderListFilterPresentationTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Orders

struct OrderListFilterPresentationTests {
    @Test(arguments: [
        (OrderListFilter.open, "orders.filter.open"),
        (.past, "orders.filter.past"),
    ])
    func titleThenNamesTheFilter(filter: OrderListFilter, key: String) {
        #expect(filter.title.key == key)
    }
}
