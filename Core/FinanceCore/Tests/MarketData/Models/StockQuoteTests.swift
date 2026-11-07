//
//  StockQuoteTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct StockQuoteTests {
    @Test func initWhenDTOIsCompleteThenMapsEveryField() throws {
        // When
        let quote = try StockQuote(QuoteDTO.apple)

        // Then
        #expect(quote.symbol == "AAPL")
        #expect(quote.companyName == "Apple Inc.")
        #expect(quote.price == Money(228.52, .usd))
        #expect(abs(quote.changePercent - 14.26) < 0.0001)
        #expect(quote.marketCap == Money(3_450_000_000_000, .usd))
        #expect(quote.isMarketOpen)
    }

    @Test(arguments: [
        QuoteDTO.appleWithoutCompanyName,
        .appleWithInvalidCurrency,
        .appleWithZeroPrice,
        .appleWithZeroPreviousClose,
    ])
    func initWhenDTOIsInvalidThenThrowsDecoding(dto: QuoteDTO) {
        // When
        let result = Result { () throws(MarketDataError) in try StockQuote(dto) }

        // Then
        #expect(result.failure == .decoding)
    }

    @Test(arguments: [(Decimal(1), true, false), (0, false, false), (-1, false, true)])
    func isGainAndIsLossThenFollowChangeSign(change: Decimal, isGain: Bool, isLoss: Bool) {
        // Given
        let quote = StockQuote(
            symbol: "AAPL",
            companyName: "Apple Inc.",
            price: Money(1, .usd),
            changePercent: change,
            marketCap: Money(1, .usd)
        )

        // Then
        #expect(quote.isGain == isGain)
        #expect(quote.isLoss == isLoss)
    }
}
