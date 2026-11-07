//
//  WatchlistContent.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

struct WatchlistContent: Equatable {
    let visibleQuotes: [StockQuote]
    let addableMatches: [SymbolMatch]
    let isSearching: Bool

    var sections: [WatchlistSection] {
        switch isSearching {
        case true: [WatchlistSection.quotesMatchingSearch, .symbolMatches].filter(hasRows)
        case false: [.quotes]
        }
    }

    var hasRows: Bool {
        !visibleQuotes.isEmpty || !addableMatches.isEmpty
    }

    var resultCount: Int {
        visibleQuotes.count + addableMatches.count
    }

    init(
        quotes: [StockQuote],
        symbolMatches: [SymbolMatch],
        searchText: String,
        sortOrder: WatchlistSortOrder
    ) {
        let visibleQuotes =
            quotes
            .filter { $0.matches(searchText) }
            .sorted(by: sortOrder.areInIncreasingOrder)
        let shownSymbols = Set(visibleQuotes.map(\.symbol))
        isSearching = !searchText.isBlank
        self.visibleQuotes = visibleQuotes
        addableMatches =
            switch isSearching {
            case true:
                symbolMatches.filter { !shownSymbols.contains($0.symbol) }
            case false:
                []
            }
    }
}

private extension WatchlistContent {
    func hasRows(_ section: WatchlistSection) -> Bool {
        switch section {
        case .quotes, .quotesMatchingSearch: !visibleQuotes.isEmpty
        case .symbolMatches: !addableMatches.isEmpty
        }
    }
}
