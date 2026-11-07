//
//  OrderDayHeadingPresentationTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import Orders

struct OrderDayHeadingPresentationTests {
    @Test(arguments: [
        (OrderDayHeading.today, "orders.day.today"),
        (.yesterday, "orders.day.yesterday"),
        (.date(Date(timeIntervalSince1970: 0)), "orders.day.date %@"),
    ])
    func titleThenNamesTheDay(heading: OrderDayHeading, key: String) {
        // Then
        #expect(heading.title.key == key)
    }
}
