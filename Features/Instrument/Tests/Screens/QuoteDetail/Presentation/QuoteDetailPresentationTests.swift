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
        // When
        let keys = appleDetail.statisticRows.map(\.title.key)

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
        // When
        let dayRange = appleDetail.statisticRows[1].value

        // Then
        let low = try #require(dayRange.firstRange(of: "99"))
        let high = try #require(dayRange.firstRange(of: "111"))
        #expect(low.lowerBound < high.lowerBound)
    }
}
