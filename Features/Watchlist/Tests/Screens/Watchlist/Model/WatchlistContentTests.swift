//
//  WatchlistContentTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Watchlist

struct WatchlistContentTests {
    @Test func initWhenNotSearchingThenSortsEveryQuoteAndOffersNoMatches() {
        // Given
        let content = makeContent(searchText: " ", sortOrder: .symbol)

        // Then
        #expect(content.visibleQuotes == [StockQuote.dummyApple, StockQuote.dummySAP])
        #expect(content.addableMatches.isEmpty)
        #expect(content.sections == [.quotes])
        #expect(content.hasRows)
        #expect(content.resultCount == 2)
    }

    @Test func initWhenSearchingThenKeepsMatchingQuotesAndMatchesNotShown() {
        // Given
        let content = makeContent(searchText: "Inc", sortOrder: .marketCap)

        // Then
        #expect(content.visibleQuotes == [StockQuote.dummyApple])
        #expect(content.addableMatches == [SymbolMatch.dummyTesla])
        #expect(content.sections == [.quotesMatchingSearch, .symbolMatches])
        #expect(content.resultCount == 2)
    }

    @Test func sectionsWhenSearchingFindsOnlyNewStocksThenShowsOnlyMatches() {
        // Given
        let content = makeContent(searchText: "Tesla", sortOrder: .marketCap)

        // Then
        #expect(content.visibleQuotes.isEmpty)
        #expect(content.sections == [.symbolMatches])
    }

    @Test func hasRowsWhenNothingMatchesThenIsFalse() {
        // Given
        let content = WatchlistContent(
            quotes: [StockQuote.dummySAP],
            symbolMatches: [],
            searchText: "Apple",
            sortOrder: .marketCap
        )

        // Then
        #expect(!content.hasRows)
        #expect(content.sections.isEmpty)
        #expect(content.resultCount == 0)
    }
}

private extension WatchlistContentTests {
    func makeContent(searchText: String, sortOrder: WatchlistSortOrder) -> WatchlistContent {
        .init(
            quotes: [StockQuote.dummySAP, StockQuote.dummyApple],
            symbolMatches: [SymbolMatch.dummyApple, SymbolMatch.dummyTesla],
            searchText: searchText,
            sortOrder: sortOrder
        )
    }
}
