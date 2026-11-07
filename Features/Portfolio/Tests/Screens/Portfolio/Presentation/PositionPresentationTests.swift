//
//  PositionPresentationTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Portfolio

struct PositionPresentationTests {
    @Test(arguments: [
        (Decimal(200), GainTrend.gain),
        (-50, .loss),
        (0, .unchanged),
    ])
    func trendThenFollowsTheTotalReturn(totalReturn: Decimal, trend: GainTrend) {
        #expect(Position.dummy("SAP", value: 1_000, totalReturn: totalReturn).trend == trend)
    }

    @Test func textsThenFormatValueReturnAndRealizedGain() {
        // Given / When
        let position = Position.dummy("SAP", value: 2_000, totalReturn: 200)

        // Then
        #expect(position.valueText == Money(2_000, .eur).formatted())
        #expect(position.returnText == Decimal.zero.formatted(.signedPercent))
        #expect(position.realizedText == Money(0, .eur).formattedSigned())
        #expect(position.realizedTrend == .unchanged)
    }

    @Test func accessibilityLabelsThenReadEachRowAsOneSentence() {
        // Given / When
        let position = Position.dummy("SAP", value: 2_000, totalReturn: 200)

        // Then
        let openKey = "portfolio.position.accessibilityLabel %@ %@ %@ %@"
        let closedKey = "portfolio.closed.accessibilityLabel %@ %@"
        #expect(position.accessibilityLabel.key == openKey)
        #expect(position.closedAccessibilityLabel.key == closedKey)
    }
}
