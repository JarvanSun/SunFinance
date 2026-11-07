//
//  ExchangeRatePresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct ExchangeRatePresentationTests {
    @Test func rowsWhenTheStockTradesInEurosThenAreEmpty() {
        // When
        let rows = ExchangeRate(currency: .eur, eurosPerUnit: 1).rows

        // Then
        #expect(rows.isEmpty)
    }

    @Test func rowsWhenTheStockTradesInDollarsThenShowOneDollarInEuros() throws {
        // When
        let row = try #require(ExchangeRate(currency: .usd, eurosPerUnit: 0.9213).rows.first)

        // Then
        #expect(row.id == "rate")
        #expect(row.title.key == "trading.review.row.rate")
        #expect(row.value.resourceKey == "trading.review.row.rate.value %@ %@")
    }
}
