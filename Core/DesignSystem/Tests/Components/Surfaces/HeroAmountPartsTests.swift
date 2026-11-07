//
//  HeroAmountPartsTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import DesignSystem

struct HeroAmountPartsTests {
    @Test(
        arguments: [
            ("de_DE", "22060.2", "EUR", "22.060", "20", nil, "€"),
            ("en_US", "19848.84", "EUR", "19,848", "84", "€", " "),
            ("en_US", "-5.07", "EUR", "-5", "07", "€", " "),
            ("de_DE", "-0.5", "EUR", "-0", "50", nil, "€"),
            ("en_US", "18420", "JPY", "18,420", "", "¥", " "),
        ] as [(String, String, String, String, String, String?, String)]
    )
    func initThenSplitsAsTheLocaleWritesTheCurrency(
        locale: String,
        amount: String,
        currency: String,
        whole: String,
        cents: String,
        leadingSymbol: String?,
        trailingSymbol: String
    ) throws {
        // Given
        let money = Money(
            try #require(Decimal(string: amount)),
            try #require(CurrencyCode(rawValue: currency))
        )

        // When
        let parts = HeroAmountParts(money, locale: Locale(identifier: locale))

        // Then
        let expected = HeroAmountParts(
            whole: whole,
            cents: cents,
            leadingSymbol: leadingSymbol,
            trailingSymbol: trailingSymbol
        )
        #expect(parts == expected)
    }
}
