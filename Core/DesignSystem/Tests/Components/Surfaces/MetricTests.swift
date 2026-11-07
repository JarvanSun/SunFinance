//
//  MetricTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import DesignSystem

struct MetricTests {
    @Test(arguments: [
        (GainTrend?.none, FinanceColor.textPrimary),
        (.gain, .gain),
        (.loss, .loss),
        (.unchanged, .unchanged),
    ])
    func valueColorThenFollowsTheTrendOrStaysPlain(trend: GainTrend?, expected: FinanceColor) {
        // Given
        let metric = Metric(id: "today", label: "Today", value: "+€1.00", trend: trend)

        // When
        let color = metric.valueColor

        // Then
        #expect(color == expected)
    }
}
