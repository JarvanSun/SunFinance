//
//  MoneyDTOTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct MoneyDTOTests {
    @Test func initThenCarriesAmountAndCurrencyCode() {
        // Given / When
        let dto = MoneyDTO(Money(12.5, .usd))

        // Then
        #expect(dto.amount == 12.5)
        #expect(dto.currency == "USD")
        #expect(MoneyDTO(euros: 3).currency == "EUR")
    }

    @Test func moneyThenMapsBackToMoney() throws {
        // Given / When
        let money = try MoneyDTO(amount: 7, currency: "EUR").money()

        // Then
        #expect(money == Money(7, .eur))
    }

    @Test func moneyWhenCurrencyIsInvalidThenThrowsDecoding() {
        // Given / When
        let result = Result { () throws(BrokerageError) in
            try MoneyDTO(amount: 7, currency: "euro").money()
        }

        // Then
        #expect(result.failure == .decoding)
    }
}
