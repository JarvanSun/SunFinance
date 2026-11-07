//
//  PortfolioHistoryPresentationTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Portfolio

struct PortfolioHistoryPresentationTests {
    @Test func chartPointsThenUseTheFirstValueAsBaseline() {
        // When
        let history = PortfolioHistory.sample

        // Then
        #expect(history.chartPoints.map(\.value) == [3_000, 3_300, 4_000])
        #expect(history.baseline == 3_000)
    }

    @Test func chartAccessibilityThenSummarizesTheRange() {
        // When
        let accessibility = PortfolioHistory.sample.chartAccessibility

        // Then
        #expect(accessibility.title.key == "portfolio.chart.title")
        #expect(accessibility.summary.key == "portfolio.chart.summary.month %@ %@")
    }
}
