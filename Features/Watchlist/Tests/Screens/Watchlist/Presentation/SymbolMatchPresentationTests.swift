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
        #expect(SymbolMatch.dummyTesla.listing.key == "watchlist.match.listing %@ %@")
    }

    @Test func accessibilityLabelThenReadsCompanySymbolAndExchange() {
        #expect(
            SymbolMatch.dummyTesla.accessibilityLabel.key
                == "watchlist.match.accessibilityLabel %@ %@ %@"
        )
    }
}
