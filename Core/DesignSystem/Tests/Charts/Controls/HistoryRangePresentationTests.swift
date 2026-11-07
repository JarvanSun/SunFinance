//
//  HistoryRangePresentationTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import DesignSystem

struct HistoryRangePresentationTests {
    @Test(arguments: [
        (HistoryRange.day, "charts.range.day"),
        (.week, "charts.range.week"),
        (.month, "charts.range.month"),
        (.threeMonths, "charts.range.threeMonths"),
        (.year, "charts.range.year"),
        (.fiveYears, "charts.range.fiveYears"),
    ])
    func titlesThenUseTheRangesKeys(range: HistoryRange, key: String) {
        // When
        let shortTitle = range.shortTitle
        let accessibilityTitle = range.accessibilityTitle

        // Then
        #expect(shortTitle.key == "\(key).short")
        #expect(accessibilityTitle.key == key)
    }
}
