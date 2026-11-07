//
//  CurrencyCodeTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct CurrencyCodeTests {
    @Test(arguments: [("EUR", CurrencyCode.eur), ("USD", .usd), ("JPY", .jpy)])
    func initWhenCodeIsSupportedThenIsItsCase(code: String, expected: CurrencyCode) {
        // When
        let currency = CurrencyCode(rawValue: code)

        // Then
        #expect(currency == expected)
    }

    @Test(arguments: ["", "EU", "EURO", "eur", "E1R", "ÉUR", "CHF"])
    func initWhenCodeIsInvalidOrUnsupportedThenFails(code: String) {
        // When
        let currency = CurrencyCode(rawValue: code)

        // Then
        #expect(currency == nil)
    }
}
