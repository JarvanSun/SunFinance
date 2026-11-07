//
//  HoldingTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct HoldingTests {
    @Test func applyWhenBuyingTwiceThenAveragesCostWithFees() {
        // Given
        var holding = Holding(symbol: "SAP", currency: .eur)

        // When
        holding.apply(.dummy(.buy, 10, at: 100))
        holding.apply(.dummy(.buy, 10, at: 120))

        // Then
        #expect(holding.quantity == 20)
        #expect(holding.costBasis == 2_202)
        #expect(holding.averageCost == Decimal(string: "110.1"))
        #expect(holding.invested == 2_202)
    }

    @Test func applyWhenSellingPartThenAverageStaysAndGainIsRealized() {
        // Given
        var holding = Holding(symbol: "SAP", currency: .eur)
        holding.apply(.dummy(.buy, 10, at: 100))
        let averageBefore = holding.averageCost

        // When
        holding.apply(.dummy(.sell, 4, at: 150))

        // Then
        #expect(holding.quantity == 6)
        #expect(holding.averageCost == averageBefore)
        #expect(holding.realizedGain == Decimal(string: "198.6"))
    }

    @Test func applyWhenSellingEverythingThenHoldingClosesWithItsGain() {
        // Given
        var holding = Holding(symbol: "SAP", currency: .eur)
        holding.apply(.dummy(.buy, 10, at: 100))

        // When
        holding.apply(.dummy(.sell, 10, at: 90))

        // Then
        #expect(!holding.isOpen)
        #expect(holding.costBasis == 0)
        #expect(holding.realizedGain == -102)
    }

    @Test func applyWhenBuyingDollarsAtTwoRatesThenTracksTheAverageRate() {
        // Given
        var holding = Holding(symbol: "AAPL", currency: .usd)

        // When
        holding.apply(
            .dummy(
                .buy,
                10,
                at: 100,
                rate: Decimal(string: "0.9")!,
                fee: 0,
                symbol: "AAPL",
                currency: .usd
            )
        )
        holding.apply(
            .dummy(
                .buy,
                10,
                at: 100,
                rate: Decimal(string: "0.95")!,
                fee: 0,
                symbol: "AAPL",
                currency: .usd
            )
        )

        // Then
        #expect(holding.averageRate == Decimal(string: "0.925"))
        #expect(holding.averageLocalCost == 100)
        #expect(holding.costBasis == 1_850)
    }
}
