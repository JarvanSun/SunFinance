//
//  HistoryRangePresentationTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Portfolio

struct HistoryRangePresentationTests {
    @Test(arguments: [
        (HistoryRange.day, "day"),
        (.week, "week"),
        (.month, "month"),
        (.threeMonths, "threeMonths"),
        (.year, "year"),
        (.fiveYears, "fiveYears"),
    ])
    func titlesThenNameTheRange(range: HistoryRange, name: String) {
        #expect(range.periodTitle.key == "portfolio.period.\(name)")
        let summary = range.chartSummary(from: "a", to: "b")
        #expect(summary.key == "portfolio.chart.summary.\(name) %@ %@")
    }

    @Test(arguments: [HistoryRange.day, .week, .month, .threeMonths, .year, .fiveYears])
    func axisDateThenLabelsEveryRange(range: HistoryRange) {
        #expect(!range.axisDate(Date(timeIntervalSince1970: 0)).isEmpty)
    }
}
