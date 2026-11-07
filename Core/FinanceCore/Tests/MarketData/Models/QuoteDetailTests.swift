//
//  QuoteDetailTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct QuoteDetailTests {
    @Test func initThenMapsRangesInTheQuotesCurrency() throws {
        // Given / When
        let detail = try QuoteDetail(dto(dayLow: 220, dayHigh: 230))

        // Then
        #expect(detail.quote.symbol == "AAPL")
        #expect(detail.open == Money(225, .usd))
        #expect(detail.dayRange == 220...230)
        #expect(detail.yearRange == 160...240)
        #expect(detail.volume == 1_000)
    }

    @Test func initWhenARangeIsInvertedThenThrowsDecoding() {
        // Given / When
        let result = Result { () throws(MarketDataError) in
            try QuoteDetail(dto(dayLow: 231, dayHigh: 230))
        }

        // Then
        #expect(result.failure == .decoding)
    }
}

private extension QuoteDetailTests {
    func dto(dayLow: Decimal, dayHigh: Decimal) -> QuoteDetailResponseDTO {
        .init(
            quote: QuoteDTO.dummy(),
            open: 225,
            dayHigh: dayHigh,
            dayLow: dayLow,
            yearHigh: 240,
            yearLow: 160,
            volume: 1_000
        )
    }
}
