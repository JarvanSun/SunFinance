//
//  QuoteDetailPresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct QuoteDetailPresentationTests {
    @Test func statisticRowsThenListFiveStatisticsInOrder() {
        // Given / When
        let keys = QuoteDetail.dummyApple.statisticRows.map(\.title.key)

        // Then
        #expect(
            keys == [
                "quoteDetail.statistics.open",
                "quoteDetail.statistics.dayRange",
                "quoteDetail.statistics.yearRange",
                "quoteDetail.statistics.marketCap",
                "quoteDetail.statistics.volume",
            ]
        )
    }

    @Test func statisticRowsThenShowRangesFromLowToHigh() throws {
        // Given / When
        let dayRange = QuoteDetail.dummyApple.statisticRows[1].value

        // Then
        let low = try #require(dayRange.firstRange(of: "99"))
        let high = try #require(dayRange.firstRange(of: "111"))
        #expect(low.lowerBound < high.lowerBound)
    }
}
