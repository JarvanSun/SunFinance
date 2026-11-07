//
//  HistorySamplingTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct HistorySamplingTests {
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        return calendar
    }

    @Test func momentsWhenMonthThenTakesWeekdayClosesAndNow() {
        // Given / When
        let moments = HistorySampling(range: .month).moments(
            endingAt: Date.dummyTuesdayAfternoon
        )

        // Then
        let closes = moments.dropLast()
        #expect(moments.last == Date.dummyTuesdayAfternoon)
        #expect(closes.allSatisfy { ![1, 7].contains(calendar.component(.weekday, from: $0)) })
        #expect(closes.allSatisfy { calendar.component(.hour, from: $0) == 21 })
        #expect((20...23).contains(closes.count))
    }

    @Test func momentsWhenFiveYearsThenTakesFridays() {
        // Given / When
        let moments = HistorySampling(range: .fiveYears).moments(
            endingAt: Date.dummyTuesdayAfternoon
        ).dropLast()

        // Then
        #expect(moments.allSatisfy { calendar.component(.weekday, from: $0) == 6 })
        #expect((259...262).contains(moments.count))
    }

    @Test func momentsWhenDayThenSamplesEvenly() {
        // Given / When
        let moments = HistorySampling(range: .day).moments(
            endingAt: Date.dummyTuesdayAfternoon
        )

        // Then
        #expect(moments.count == 120)
        #expect(moments.last == Date.dummyTuesdayAfternoon)
    }
}
