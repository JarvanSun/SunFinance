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
        (WatchlistSortOrder.marketCap, [StockQuote.apple, .sap, .unchanged]),
        (.dailyChange, [.apple, .unchanged, .sap]),
        (.symbol, [.apple, .unchanged, .sap]),
    ])
    func areInIncreasingOrderThenSortsByOrder(order: WatchlistSortOrder, expected: [StockQuote]) {
        // Given
        let quotes: [StockQuote] = [.sap, .unchanged, .apple]

        // When
        let sortedQuotes = quotes.sorted(by: order.areInIncreasingOrder)

        // Then
        #expect(sortedQuotes == expected)
    }
}
