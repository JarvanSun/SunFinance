//
//  PortfolioHeaderPresentationTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Portfolio

struct PortfolioHeaderPresentationTests {
    @Test(arguments: [
        (Decimal(12), GainTrend.gain),
        (-3, .loss),
        (0, .unchanged),
    ])
    func trendThenFollowsTheChange(change: Decimal, trend: GainTrend) {
        // Given
        let header = makeHeader(change: .known(Money(change, .eur), percent: 0))

        // Then
        #expect(header.trend == trend)
        #expect(header.changeText == Money(change, .eur).formattedSigned())
        #expect(header.changeValue == Money(change, .eur).doubleValue)
    }

    @Test func changeTextWhenPendingThenReservesTheLineWithoutANumber() {
        // Given
        let header = makeHeader(change: .pending)

        // Then
        #expect(header.changeText == "\u{00A0}")
        #expect(header.trend == .unchanged)
        #expect(header.changeValue == 0)
    }
}

private extension PortfolioHeaderPresentationTests {
    func makeHeader(change: PortfolioChange) -> PortfolioHeader {
        PortfolioHeader(value: Money(100, .eur), change: change, moment: .range(.month))
    }
}
