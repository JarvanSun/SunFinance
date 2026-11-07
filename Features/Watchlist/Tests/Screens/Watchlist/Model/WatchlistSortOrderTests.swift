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
        (WatchlistSortOrder.marketCap, [appleQuote, sapQuote, unchangedQuote]),
        (.dailyChange, [appleQuote, unchangedQuote, sapQuote]),
        (.symbol, [appleQuote, unchangedQuote, sapQuote]),
    ])
    func areInIncreasingOrderThenSortsByOrder(order: WatchlistSortOrder, expected: [StockQuote]) {
        // Given
        let quotes: [StockQuote] = [sapQuote, unchangedQuote, appleQuote]

        // When
        let sortedQuotes = quotes.sorted(by: order.areInIncreasingOrder)

        // Then
        #expect(sortedQuotes == expected)
    }
}
