//
//  StockQuoteMatchingTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Watchlist

struct StockQuoteMatchingTests {
    @Test(arguments: [("", true), ("  ", true), ("aapl", true), ("apple", true), ("SAP", false)])
    func matchesThenComparesSymbolAndCompanyName(query: String, expected: Bool) {
        // Given / When
        let matches = StockQuote.dummyApple.matches(query)

        // Then
        #expect(matches == expected)
    }
}
