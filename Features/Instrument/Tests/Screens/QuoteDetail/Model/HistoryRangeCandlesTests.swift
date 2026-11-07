//
//  HistoryRangeCandlesTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Instrument

struct HistoryRangeCandlesTests {
    @Test(arguments: [
        (HistoryRange.day, false),
        (.week, false),
        (.month, true),
        (.threeMonths, true),
        (.year, true),
        (.fiveYears, true),
    ])
    func isLongEnoughForCandlesThenFromOneMonth(range: HistoryRange, expected: Bool) {
        #expect(range.isLongEnoughForCandles == expected)
    }
}
