//
//  CurrencyCodeTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct CurrencyCodeTests {
    @Test(arguments: ["EUR", "USD", "CHF"])
    func initWhenCodeIsThreeUppercaseLettersThenKeepsIt(code: String) {
        // When
        let currency = CurrencyCode(rawValue: code)

        // Then
        #expect(currency?.rawValue == code)
    }

    @Test(arguments: ["", "EU", "EURO", "eur", "E1R", "ÉUR"])
    func initWhenCodeIsInvalidThenFails(code: String) {
        // When
        let currency = CurrencyCode(rawValue: code)

        // Then
        #expect(currency == nil)
    }

    @Test func presetsThenAreTheirCodes() {
        // Then
        #expect(CurrencyCode.eur.rawValue == "EUR")
        #expect(CurrencyCode.usd.rawValue == "USD")
    }
}
