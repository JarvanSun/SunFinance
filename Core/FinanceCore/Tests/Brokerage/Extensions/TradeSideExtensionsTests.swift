//
//  TradeSideExtensionsTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct TradeSideExtensionsTests {
    @Test(arguments: [(TradeSide.buy, Decimal(-101)), (.sell, 99)])
    func cashEffectThenPaysOutForBuysAndBringsInForSells(side: TradeSide, expected: Decimal) {
        // When
        let cashEffect = side.cashEffect(gross: 100, fee: 1)

        // Then
        #expect(cashEffect == expected)
    }

    @Test(arguments: TradeSide.allCases)
    func totalThenIsWhatTheTradeCostOrPaidOut(side: TradeSide) {
        // When
        let total = side.total(ofCashEffect: side.cashEffect(gross: 100, fee: 1))

        // Then
        #expect(total == (side == .buy ? 101 : 99))
    }
}
