//
//  HistoryRangeMomentStyleTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct HistoryRangeMomentStyleTests {
    @Test(arguments: [
        (HistoryRange.day, false, true),
        (.week, false, true),
        (.month, false, true),
        (.threeMonths, true, false),
        (.year, true, false),
        (.fiveYears, true, false),
    ])
    func momentStyleThenNamesTimeForShortRangesAndYearForLongOnes(
        range: HistoryRange,
        showsYear: Bool,
        showsTime: Bool
    ) throws {
        // Given
        let moment = Date(timeIntervalSince1970: 1_793_000_000)
        var style = range.momentStyle.locale(Locale(identifier: "en_US_POSIX"))
        style.timeZone = try #require(TimeZone(identifier: "UTC"))

        // When
        let text = moment.formatted(style)

        // Then
        #expect(text.contains("2026") == showsYear)
        #expect(text.contains(":") == showsTime)
    }
}
