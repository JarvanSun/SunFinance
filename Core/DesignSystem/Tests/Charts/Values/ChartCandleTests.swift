//
//  ChartCandleTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import DesignSystem

struct ChartCandleTests {
    @Test(arguments: [(10.0, 11.0, GainTrend.gain), (11, 10, .loss), (10, 10, .unchanged)])
    func trendThenComparesCloseWithOpen(open: Double, close: Double, expected: GainTrend) {
        // Given
        let candle = ChartCandle(date: .now, open: open, high: 12, low: 9, close: close, volume: 1)

        // When
        let trend = candle.trend

        // Then
        #expect(trend == expected)
    }
}
