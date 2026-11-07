//
//  SymbolMatchPresentationTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Watchlist

struct SymbolMatchPresentationTests {
    @Test func listingThenNamesSymbolAndExchange() {
        // Then
        #expect(SymbolMatch.tesla.listing.key == "watchlist.match.listing %@ %@")
    }

    @Test func accessibilityLabelThenReadsCompanySymbolAndExchange() {
        // Then
        #expect(
            SymbolMatch.tesla.accessibilityLabel.key
                == "watchlist.match.accessibilityLabel %@ %@ %@"
        )
    }
}
