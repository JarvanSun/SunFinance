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
        // Given / When
        let formattedChange = StockQuote.dummyApple.formattedChange

        // Then
        #expect(formattedChange.hasPrefix("+"))
    }

    @Test(arguments: [
        (StockQuote.dummyApple, GainTrend.gain),
        (StockQuote.dummySAP, .loss),
        (StockQuote.dummyUnchanged, .unchanged),
    ])
    func trendThenFollowsDailyChange(quote: StockQuote, expected: GainTrend) {
        #expect(quote.trend == expected)
    }

    @Test func accessibilityLabelThenReadsCompanyPriceAndChange() {
        #expect(
            StockQuote.dummyApple.accessibilityLabel.key
                == "watchlist.row.accessibilityLabel %@ %@ %@"
        )
    }
}
