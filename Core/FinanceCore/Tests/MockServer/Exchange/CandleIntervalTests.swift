//
//  CandleIntervalTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct CandleIntervalTests {
    @Test(arguments: [
        (HistoryRange.day, CandleInterval.intraday(300, sessions: 1)),
        (.week, .intraday(1_800, sessions: 5)),
        (.month, .intraday(3_600, sessions: 22)),
        (.threeMonths, .sessions(63, sessionsPerCandle: 1)),
        (.year, .sessions(252, sessionsPerCandle: 1)),
        (.fiveYears, .sessions(1_260, sessionsPerCandle: 5)),
    ])
    func initThenCutsEachRangeSensibly(range: HistoryRange, expected: CandleInterval) {
        // Then
        #expect(CandleInterval(range) == expected)
    }
}
