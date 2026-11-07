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
        let formattedChange = appleQuote.formattedChange

        // Then
        #expect(formattedChange.hasPrefix("+"))
    }

    @Test(arguments: [
        (appleQuote, GainTrend.gain),
        (sapQuote, .loss),
        (unchangedQuote, .unchanged),
    ])
    func trendThenFollowsDailyChange(quote: StockQuote, expected: GainTrend) {
        // Then
        #expect(quote.trend == expected)
    }

    @Test func accessibilityLabelThenReadsCompanyPriceAndChange() {
        // Then
        #expect(
            appleQuote.accessibilityLabel.key == "watchlist.row.accessibilityLabel %@ %@ %@"
        )
    }
}
