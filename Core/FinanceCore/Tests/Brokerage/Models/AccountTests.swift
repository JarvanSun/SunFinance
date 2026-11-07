//
//  AccountTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct AccountTests {
    @Test func initThenMapsEveryField() throws {
        // Given / When
        let account = try Account(dto())

        // Then
        #expect(account.cash == Money(100, .eur))
        #expect(account.buyingPower == Money(80, .eur))
        #expect(account.positionsValue == Money(900, .eur))
        #expect(account.total == Money(1_000, .eur))
        #expect(account.todayGain == Money(-5, .eur))
    }

    @Test func initWhenACurrencyIsInvalidThenThrowsDecoding() {
        // Given / When
        let result = Result { () throws(BrokerageError) in try Account(dto(currency: "E")) }

        // Then
        #expect(result.failure == .decoding)
    }
}

private extension AccountTests {
    func dto(currency: String = "EUR") -> AccountResponseDTO {
        .init(
            cash: .init(euros: 100),
            buyingPower: .init(euros: 80),
            positionsValue: .init(euros: 900),
            total: .init(euros: 1_000),
            todayGain: MoneyDTO(amount: -5, currency: currency)
        )
    }
}
