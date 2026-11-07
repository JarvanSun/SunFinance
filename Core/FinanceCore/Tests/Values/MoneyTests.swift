//
//  MoneyTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct MoneyTests {
    @Test func initThenKeepsAmountAndCurrency() {
        // When
        let money = Money(228.52, .usd)

        // Then
        #expect(money.amount == 228.52)
        #expect(money.currency == .usd)
    }

    @Test func codingThenRoundTrips() throws {
        // Given
        let money = Money(10_000, .eur)

        // When
        let decoded = try JSONDecoder().decode(Money.self, from: JSONEncoder().encode(money))

        // Then
        #expect(decoded == money)
    }
}
