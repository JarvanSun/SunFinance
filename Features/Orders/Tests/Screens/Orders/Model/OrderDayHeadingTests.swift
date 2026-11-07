//
//  OrderDayHeadingTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import Orders

struct OrderDayHeadingTests {
    @Test(arguments: [
        (Date(timeIntervalSince1970: 86_400), OrderDayHeading.today),
        (Date(timeIntervalSince1970: 0), .yesterday),
        (Date(timeIntervalSince1970: -86_400), .date(Date(timeIntervalSince1970: -86_400))),
    ])
    func initThenNamesTodayAndYesterday(day: Date, expected: OrderDayHeading) {
        // Given
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!

        // When
        let heading = OrderDayHeading(
            day: day,
            calendar: calendar,
            now: Date(timeIntervalSince1970: 86_400 + 3_600)
        )

        // Then
        #expect(heading == expected)
    }
}
