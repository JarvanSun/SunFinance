//
//  WatchlistEventTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Watchlist

struct WatchlistEventTests {
    @Test func favoriteToggledThenCarriesSymbolAndState() {
        // Given
        let event = WatchlistEvent.favoriteToggled(symbol: "AAPL", isFavorite: true)

        // Then
        #expect(event.name == .init("watchlist_favorite_toggled"))
        #expect(event.parameters == [.symbol: .text("AAPL"), .isFavorite: .boolean(true)])
    }

    @Test(arguments: [
        (WatchlistIssue.offline, "offline"),
        (.serviceUnavailable, "service_unavailable"),
        (.unreadableData, "unreadable_data"),
    ])
    func quotesFailedThenReportsReason(issue: WatchlistIssue, expectedReason: String) {
        // Given
        let event = WatchlistEvent.quotesFailed(issue)

        // Then
        #expect(event.parameters == [.failureReason: .text(expectedReason)])
    }

    @Test func symbolAddedThenCarriesSymbol() {
        // Given
        let event = WatchlistEvent.symbolAdded(symbol: "TSLA")

        // Then
        #expect(event.name == .init("watchlist_symbol_added"))
        #expect(event.parameters == [.symbol: .text("TSLA")])
    }

    @Test func searchSubmittedThenNeverCarriesQueryText() {
        // Given
        let event = WatchlistEvent.searchSubmitted(resultCount: 2)

        // Then
        #expect(event.parameters == [.resultCount: .integer(2)])
    }
}
