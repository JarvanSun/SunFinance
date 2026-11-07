//
//  TradingVenueTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct TradingVenueTests {
    @Test(arguments: [
        (TradingVenue.nasdaq, "2026-11-04T15:00:00Z", true),
        (.nasdaq, "2026-11-04T22:00:00Z", false),
        (.xetra, "2026-11-04T09:00:00Z", true),
        (.xetra, "2026-11-04T17:00:00Z", false),
        (.xetra, "2026-11-07T10:00:00Z", false),
    ])
    func isOpenThenFollowsRegularHoursOnWeekdays(venue: TradingVenue, moment: String, isOpen: Bool)
        throws
    {
        // Given
        let date = try #require(ISO8601DateFormatter().date(from: moment))

        // Then
        #expect(venue.isOpen(at: date) == isOpen)
    }

    @Test func closesWhenAskedOnSaturdayThenStartWithFridayClose() throws {
        // Given
        let saturday = try #require(ISO8601DateFormatter().date(from: "2026-11-07T10:00:00Z"))
        let fridayClose = try #require(ISO8601DateFormatter().date(from: "2026-11-06T16:30:00Z"))

        // When
        let closes = TradingVenue.xetra.closes(atOrBefore: saturday)

        // Then
        #expect(closes.first == fridayClose)
        #expect(closes.allSatisfy { $0 <= saturday })
    }

    @Test func sessionsThenReturnsWeekdaySessionsOldestFirstAndCutsTheRunningOne() throws {
        // Given
        let wednesdayNoon = try #require(ISO8601DateFormatter().date(from: "2026-11-04T11:00:00Z"))

        // When
        let sessions = TradingVenue.xetra.sessions(endingAtOrBefore: wednesdayNoon, count: 3)

        // Then
        #expect(sessions.count == 3)
        #expect(sessions.last?.upperBound == wednesdayNoon)
        #expect(zip(sessions, sessions.dropFirst()).allSatisfy { $0.upperBound < $1.lowerBound })
    }
}
