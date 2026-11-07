//
//  GainTrendTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

struct GainTrendTests {
    @Test(arguments: [
        (Decimal(5), GainTrend.gain),
        (Decimal(-0.01), .loss),
        (Decimal(0), .unchanged),
    ])
    func initWhenGivenAChangeThenFollowsItsSign(change: Decimal, expected: GainTrend) {
        // When
        let trend = GainTrend(change)

        // Then
        #expect(trend == expected)
    }

    @Test(arguments: [
        (1.0, 2.0, GainTrend.gain),
        (2, 1, .loss),
        (1, 1, .unchanged),
    ])
    func initWhenGivenTwoValuesThenComparesEndWithStart(
        start: Double,
        end: Double,
        expected: GainTrend
    ) {
        // When
        let trend = GainTrend(from: start, to: end)

        // Then
        #expect(trend == expected)
    }

    @Test(arguments: [
        (GainTrend.gain, FinanceColor.gain),
        (.loss, .loss),
        (.unchanged, .unchanged),
    ])
    func colorThenUsesTheMarketColor(trend: GainTrend, expected: FinanceColor) {
        // When
        let color = trend.color

        // Then
        #expect(color == expected)
    }
}
