//
//  PriceHistoryTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct PriceHistoryTests {
    @Test func initWhenPreviousCloseIsGivenThenItIsTheBaseline() throws {
        // When
        let history = try PriceHistory(dto(previousClose: 100))

        // Then
        #expect(history.baseline == 100)
        #expect(history.range == .day)
        #expect(history.currency == .eur)
        #expect(history.candles.count == 2)
    }

    @Test func initWithoutPreviousCloseThenFirstOpenIsTheBaseline() throws {
        // When
        let history = try PriceHistory(dto(previousClose: nil))

        // Then
        #expect(history.baseline == 10)
    }

    @Test func initWhenCurrencyIsInvalidThenThrowsDecoding() {
        // When
        let result = Result { () throws(MarketDataError) in
            try PriceHistory(dto(previousClose: nil, currency: "EURO"))
        }

        // Then
        #expect(result.failure == .decoding)
    }
}

private extension PriceHistoryTests {
    func dto(previousClose: Decimal?, currency: String = "EUR") -> PriceHistoryResponseDTO {
        PriceHistoryResponseDTO(
            symbol: "SAP",
            range: "1D",
            currency: currency,
            previousClose: previousClose,
            candles: [
                CandleDTO(
                    start: Date(timeIntervalSince1970: 0),
                    open: 10,
                    high: 12,
                    low: 9,
                    close: 11,
                    volume: 5
                ),
                CandleDTO(
                    start: Date(timeIntervalSince1970: 300),
                    open: 11,
                    high: 13,
                    low: 10,
                    close: 12,
                    volume: 7
                ),
            ]
        )
    }
}
