//
//  PortfolioValuePointTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct PortfolioValuePointTests {
    @Test func initThenMapsDateAndValue() throws {
        // When
        let point = try PortfolioValuePoint(
            ValuePointDTO(date: Date(timeIntervalSince1970: 60), value: .init(euros: 10_500))
        )

        // Then
        #expect(point.date == Date(timeIntervalSince1970: 60))
        #expect(point.value == Money(10_500, .eur))
    }

    @Test func initWhenCurrencyIsInvalidThenThrowsDecoding() {
        // When
        let result = Result { () throws(BrokerageError) in
            try PortfolioValuePoint(
                ValuePointDTO(date: Date(), value: MoneyDTO(amount: 1, currency: "EURO"))
            )
        }

        // Then
        #expect(result.failure == .decoding)
    }
}
