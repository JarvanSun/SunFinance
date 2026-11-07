//
//  StockQuotePresentationTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Watchlist

struct StockQuotePresentationTests {
    @Test func formattedChangeThenIsSigned() {
        // When
        let formattedChange = StockQuote.apple.formattedChange

        // Then
        #expect(formattedChange.hasPrefix("+"))
    }

    @Test(arguments: [
        (StockQuote.apple, GainTrend.gain),
        (.sap, .loss),
        (.unchanged, .unchanged),
    ])
    func trendThenFollowsDailyChange(quote: StockQuote, expected: GainTrend) {
        // Then
        #expect(quote.trend == expected)
    }

    @Test func accessibilityLabelThenReadsCompanyPriceAndChange() {
        // Then
        #expect(
            StockQuote.apple.accessibilityLabel.key == "watchlist.row.accessibilityLabel %@ %@ %@"
        )
    }
}
