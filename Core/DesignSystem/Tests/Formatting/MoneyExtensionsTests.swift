//
//  MoneyExtensionsTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

struct MoneyExtensionsTests {
    @Test(arguments: [
        (Decimal(string: "1234.56")!, "en_US", "€1,234.56"),
        (Decimal(string: "1234.56")!, "de_DE", "1.234,56\u{00A0}€"),
        (Decimal(string: "-5.1")!, "en_US", "-€5.10"),
    ])
    func formattedThenWritesTheCurrencyTheLocaleWay(
        amount: Decimal,
        localeIdentifier: String,
        expected: String
    ) {
        // Given
        let money = Money(amount, .eur)

        // When
        let text = money.formatted(locale: Locale(identifier: localeIdentifier))

        // Then
        #expect(text == expected)
    }

    @Test(arguments: [
        (Decimal(string: "250.46")!, "+$250.46"),
        (Decimal(string: "-12.4")!, "-$12.40"),
        (Decimal(0), "$0.00"),
    ])
    func formattedSignedThenSignsEverythingButZero(amount: Decimal, expected: String) {
        // Given
        let money = Money(amount, .usd)

        // When
        let text = money.formattedSigned(locale: Locale(identifier: "en_US"))

        // Then
        #expect(text == expected)
    }

    @Test func doubleValueThenKeepsTheAmount() {
        // Given
        let money = Money(Decimal(string: "231.42")!, .usd)

        // When
        let value = money.doubleValue

        // Then
        #expect(value == 231.42)
    }
}
