//
//  OrderFillTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct OrderFillTests {
    @Test func initThenMapsEveryField() throws {
        // When
        let fill = try OrderFill(FillDTO())

        // Then
        #expect(fill.date == Date(timeIntervalSince1970: 1_000))
        #expect(fill.quantity == 2)
        #expect(fill.price == Money(100, .usd))
        #expect(fill.exchangeRate == 0.9)
        #expect(fill.fee == Money(1, .eur))
        #expect(fill.total == Money(181, .eur))
    }

    @Test func initWhenACurrencyIsInvalidThenThrowsDecoding() {
        // When
        let result = Result { () throws(BrokerageError) in try OrderFill(.init(currency: "us")) }

        // Then
        #expect(result.failure == .decoding)
    }
}
