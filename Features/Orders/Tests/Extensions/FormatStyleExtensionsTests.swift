//
//  FormatStyleExtensionsTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import Orders

struct FormatStyleExtensionsTests {
    @Test func orderMomentThenShowsMonthDayAndTime() {
        // Given
        var style = Date.FormatStyle.orderMoment.locale(Locale(identifier: "en_US"))
        style.timeZone = TimeZone(identifier: "UTC")!

        // When
        let text = Date(timeIntervalSince1970: 0).formatted(style)

        // Then
        #expect(text == "Jan 1 at 12:00\u{202F}AM")
    }
}
