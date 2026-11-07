//
//  CompactCurrencyFormatStyleTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

struct CompactCurrencyFormatStyleTests {
    @Test func formatWhenValueIsTrillionsThenUsesCompactNotation() {
        // Given
        let style = CompactCurrencyFormatStyle(currency: .usd, locale: Locale(identifier: "en_US"))

        // When
        let formatted = style.format(3_450_000_000_000)

        // Then
        #expect(formatted == "$3.45T")
    }

    @Test func localeThenKeepsTheCurrency() {
        // Given
        let style = CompactCurrencyFormatStyle.compactCurrency(code: .eur)

        // When
        let german = style.locale(Locale(identifier: "de_DE"))

        // Then
        #expect(german.currency == .eur)
        #expect(german.locale.identifier == "de_DE")
    }
}
