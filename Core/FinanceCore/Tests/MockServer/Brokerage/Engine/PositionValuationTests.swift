//
//  PositionValuationTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct PositionValuationTests {
    @Test func gainsThenCompareMarketValueWithCostBasis() {
        // Given
        let valuation = makeValuation(price: 120, fillsToday: [])

        // Then
        #expect(valuation.marketValue == 1_200)
        #expect(valuation.unrealizedGain == 199)
        #expect(valuation.totalReturn == 199)
    }

    @Test func todayGainThenCountsHeldSharesAndTodaysFills() {
        // Given
        let todaysBuy = LedgerFill.dummy(.buy, 5, at: 115)
        let valuation = makeValuation(
            price: 120,
            quantityAtPreviousClose: 10,
            fillsToday: [todaysBuy]
        )

        // Then
        #expect(valuation.todayGain == Decimal(125))
    }

    @Test(arguments: [
        ([LedgerFill.dummy(.sell, 10, at: 105)], Decimal(10), Decimal(50)),
        ([.dummy(.sell, 4, at: 105)], 10, 80),
        ([.dummy(.buy, 5, at: 108), .dummy(.sell, 5, at: 112)], 0, 20),
        ([.dummy(.sell, 10, at: 105), .dummy(.buy, 2, at: 104)], 10, 62),
    ])
    func todayGainWhenSellingTodayThenCountsTheSalePriceForTheSoldShares(
        fillsToday: [LedgerFill],
        quantityAtPreviousClose: Decimal,
        expected: Decimal
    ) {
        // Given
        let valuation = makeValuation(
            price: 110,
            previousClose: 100,
            quantityAtPreviousClose: quantityAtPreviousClose,
            fillsToday: fillsToday
        )

        // Then
        #expect(valuation.todayGain == expected)
    }

    @Test func percentagesThenCompareWithCostBasisAndInvested() {
        // Given
        let valuation = makeValuation(price: 120, fillsToday: [])

        // Then
        #expect(valuation.unrealizedGainPercent == Decimal(199) / 1_001 * 100)
        #expect(valuation.totalReturnPercent == Decimal(199) / 1_001 * 100)
    }

    @Test func currencyEffectWhenTheDollarWeakensThenIsALoss() {
        // Given
        var holding = Holding(symbol: "AAPL", currency: .usd)
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
        let valuation = PositionValuation(
            holding: holding,
            price: 110,
            rate: Decimal(string: "0.9")!,
            previousClose: 110,
            previousRate: Decimal(string: "0.9")!,
            quantityAtPreviousClose: 10,
            fillsToday: []
        )

        // Then
        #expect(valuation.currencyEffect == Decimal(string: "-55"))
        #expect(valuation.unrealizedGain == Decimal(string: "40"))
    }
}

private extension PositionValuationTests {
    func makeValuation(
        price: Decimal,
        previousClose: Decimal = 110,
        quantityAtPreviousClose: Decimal = 10,
        fillsToday: [LedgerFill]
    ) -> PositionValuation {
        var holding = Holding(symbol: "SAP", currency: .eur)
        holding.apply(.dummy(.buy, 10, at: 100))
        return .init(
            holding: holding,
            price: price,
            rate: 1,
            previousClose: previousClose,
            previousRate: 1,
            quantityAtPreviousClose: quantityAtPreviousClose,
            fillsToday: fillsToday
        )
    }
}
