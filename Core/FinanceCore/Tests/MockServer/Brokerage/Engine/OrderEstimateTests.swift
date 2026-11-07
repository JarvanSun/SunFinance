//
//  OrderEstimateTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct OrderEstimateTests {
    @Test(arguments: [(TradeSide.buy, Decimal(-181), Decimal(181)), (.sell, 179, 179)])
    func cashEffectAndTotalThenConvertAndIncludeTheFee(
        side: TradeSide,
        cashEffect: Decimal,
        total: Decimal
    ) {
        // Given
        let estimate = OrderEstimate(quantity: 2, price: 100, currency: .usd, rate: 0.9, fee: 1)

        // Then
        #expect(estimate.cashEffect(for: side) == cashEffect)
        #expect(estimate.total(for: side) == total)
    }
}
