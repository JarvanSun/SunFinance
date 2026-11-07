//
//  WatchlistSortOrderTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Watchlist

struct WatchlistSortOrderTests {
    @Test(arguments: [
        (
            WatchlistSortOrder.marketCap,
            [StockQuote.dummyApple, StockQuote.dummySAP, StockQuote.dummyUnchanged]
        ),
        (.dailyChange, [StockQuote.dummyApple, StockQuote.dummyUnchanged, StockQuote.dummySAP]),
        (.symbol, [StockQuote.dummyApple, StockQuote.dummyUnchanged, StockQuote.dummySAP]),
    ])
    func areInIncreasingOrderThenSortsByOrder(order: WatchlistSortOrder, expected: [StockQuote]) {
        // Given
        let quotes: [StockQuote] = [
            StockQuote.dummySAP, StockQuote.dummyUnchanged, StockQuote.dummyApple,
        ]

        // When
        let sortedQuotes = quotes.sorted(by: order.areInIncreasingOrder)

        // Then
        #expect(sortedQuotes == expected)
    }
}
