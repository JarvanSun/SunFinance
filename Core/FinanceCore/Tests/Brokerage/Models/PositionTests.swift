//
//  PositionTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct PositionTests {
    @Test func initThenMapsEveryField() throws {
        // When
        let position = try Position(PositionDTO())

        // Then
        #expect(position.symbol == "AAPL")
        #expect(position.id == "AAPL")
        #expect(position.quantity == 10)
        #expect(position.isOpen)
        #expect(position.price == Money(110, .usd))
        #expect(position.averageCost == Money(91, .eur))
        #expect(position.averageLocalCost == Money(100, .usd))
        #expect(position.costBasis == Money(910, .eur))
        #expect(position.marketValue == Money(990, .eur))
        #expect(position.unrealizedGain == Money(80, .eur))
        #expect(position.unrealizedGainPercent == 8.79)
        #expect(position.realizedGain == Money(12, .eur))
        #expect(position.todayGain == Money(-3, .eur))
        #expect(position.currencyEffect == Money(-20, .eur))
        #expect(position.totalReturn == Money(92, .eur))
        #expect(position.totalReturnPercent == 9.2)
    }

    @Test func initWhenACurrencyIsInvalidThenThrowsDecoding() {
        // When
        let result = Result { () throws(BrokerageError) in try Position(.init(currency: "x")) }

        // Then
        #expect(result.failure == .decoding)
    }
}
