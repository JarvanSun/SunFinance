//
//  MockExchangeTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct MockExchangeTests {
    @Test func quoteWhenAskedTwiceForSameMomentThenIsIdentical() throws {
        // Given
        let exchange = MockExchange()
        let moment = try date("2026-11-04T15:00:00Z")

        // When
        let first = exchange.quote(for: "AAPL", at: moment)
        let second = exchange.quote(for: "AAPL", at: moment)

        // Then
        #expect(first != nil)
        #expect(first == second)
    }

    @Test func quoteWhenMarketIsOpenThenPriceMovesWithinTheSession() throws {
        // Given
        let exchange = MockExchange()

        // When
        let morning = exchange.quote(for: "AAPL", at: try date("2026-11-04T15:00:00Z"))
        let afternoon = exchange.quote(for: "AAPL", at: try date("2026-11-04T19:00:00Z"))

        // Then
        #expect(morning?.isMarketOpen == true)
        #expect(morning?.price != afternoon?.price)
    }

    @Test func quoteWhenMarketIsClosedThenPriceStaysAtLastClose() throws {
        // Given
        let exchange = MockExchange()

        // When
        let saturdayMorning = exchange.quote(for: "SAP", at: try date("2026-11-07T08:00:00Z"))
        let saturdayEvening = exchange.quote(for: "SAP", at: try date("2026-11-07T20:00:00Z"))

        // Then
        #expect(saturdayMorning?.isMarketOpen == false)
        #expect(saturdayMorning?.price == saturdayEvening?.price)
        #expect(saturdayMorning?.price.currency == .eur)
    }

    @Test func quoteWhenSymbolIsNotListedThenIsNil() throws {
        // Given
        let exchange = MockExchange()

        // Then
        #expect(exchange.quote(for: "ZZZZ", at: try date("2026-11-04T15:00:00Z")) == nil)
    }

    @Test func pricesThenStayNearTheReferencePrice() throws {
        // Given
        let exchange = MockExchange()
        let moments = try (0..<48).map {
            try date("2026-11-02T00:00:00Z").addingTimeInterval(Double($0) * 3_600)
        }

        // When
        let prices = moments.compactMap { exchange.quote(for: "ALV", at: $0)?.price.amount }

        // Then
        #expect(prices.allSatisfy { $0 > 240 && $0 < 340 })
    }
}

extension MockExchangeTests {
    @Test(arguments: [(HistoryRange.day, 102), (.year, 252), (.fiveYears, 252)])
    func candlesThenCoverTheRangeOldestFirst(range: HistoryRange, count: Int) throws {
        // Given
        let exchange = MockExchange()
        let saturday = try date("2026-11-07T12:00:00Z")

        // When
        let candles = exchange.candles(for: "SAP", range: range, endingAt: saturday)

        // Then
        #expect(candles.count == count)
        #expect(zip(candles, candles.dropFirst()).allSatisfy { $0.start < $1.start })
        #expect(
            candles.allSatisfy {
                $0.low <= min($0.open, $0.close) && $0.high >= max($0.open, $0.close)
            }
        )
        #expect(candles.allSatisfy { $0.volume > 0 })
    }

    @Test func candlesWhenDayIsRunningThenStopAtNow() throws {
        // Given
        let exchange = MockExchange()
        let noon = try date("2026-11-04T17:00:00Z")

        // When
        let candles = exchange.candles(for: "AAPL", range: .day, endingAt: noon)

        // Then
        #expect(candles.count == 30)
        #expect(candles.last.map { $0.start < noon } == true)
    }

    @Test func eurRateThenIsOneForEuroAndDriftsForDollar() throws {
        // Given
        let exchange = MockExchange()
        let early = try date("2026-08-01T12:00:00Z")
        let late = try date("2026-10-01T12:00:00Z")

        // When
        let earlyRate = exchange.eurRate(of: .usd, at: early)
        let lateRate = exchange.eurRate(of: .usd, at: late)

        // Then
        #expect(exchange.eurRate(of: .eur, at: early) == 1)
        #expect(earlyRate != lateRate)
        #expect([earlyRate, lateRate].allSatisfy { $0 > 0.85 && $0 < 1 })
    }

    @Test func priceThenIgnoresTradingHours() throws {
        // Given
        let exchange = MockExchange()

        // Then
        #expect(exchange.price(of: "SAP", at: try date("2026-11-07T08:00:00Z")) != nil)
        #expect(exchange.price(of: "ZZZZ", at: try date("2026-11-07T08:00:00Z")) == nil)
    }
}

private extension MockExchangeTests {
    func date(_ moment: String) throws -> Date {
        try #require(ISO8601DateFormatter().date(from: moment))
    }
}
