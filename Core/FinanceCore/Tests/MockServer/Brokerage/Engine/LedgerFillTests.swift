//
//  LedgerFillTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct LedgerFillTests {
    @Test func grossAndPriceInEurosThenConvertAtTheFillsRate() {
        // Given
        let fill = LedgerFill.make(.buy, 10, at: 100, rate: 0.9, symbol: "AAPL", currency: .usd)

        // Then
        #expect(fill.grossInEuros == 900)
        #expect(fill.priceInEuros == 90)
    }

    @Test(arguments: [(TradeSide.buy, Decimal(-901), Decimal(901)), (.sell, 899, 899)])
    func cashEffectAndTotalThenIncludeTheFee(side: TradeSide, cashEffect: Decimal, total: Decimal) {
        // Given
        let fill = LedgerFill.make(side, 10, at: 100, rate: 0.9, symbol: "AAPL", currency: .usd)

        // Then
        #expect(fill.cashEffect == cashEffect)
        #expect(fill.total == total)
    }
}
