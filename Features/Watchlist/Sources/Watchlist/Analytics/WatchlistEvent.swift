//
//  WatchlistEvent.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum WatchlistEvent: AnalyticsEvent, Equatable {
    case screenViewed
    case quotesLoaded(count: Int)
    case quotesFailed(WatchlistIssue)
    case searchSubmitted(resultCount: Int)
    case sortOrderChanged(WatchlistSortOrder)
    case favoriteToggled(symbol: TickerSymbol, isFavorite: Bool)
    case quoteOpened(symbol: TickerSymbol)
    case symbolAdded(symbol: TickerSymbol)

    var name: AnalyticsEventName {
        switch self {
        case .screenViewed:
            .watchlistViewed
        case .quotesLoaded:
            .watchlistQuotesLoaded
        case .quotesFailed:
            .watchlistQuotesFailed
        case .searchSubmitted:
            .watchlistSearchSubmitted
        case .sortOrderChanged:
            .watchlistSortChanged
        case .favoriteToggled:
            .watchlistFavoriteToggled
        case .quoteOpened:
            .watchlistQuoteOpened
        case .symbolAdded:
            .watchlistSymbolAdded
        }
    }

    var parameters: [AnalyticsParameter: AnalyticsValue] {
        switch self {
        case .screenViewed:
            [:]
        case .quotesLoaded(let count), .searchSubmitted(let count):
            [.resultCount: .integer(count)]
        case .quotesFailed(let issue):
            [.failureReason: .text(issue.analyticsValue)]
        case .sortOrderChanged(let order):
            [.sortOrder: .text(order.rawValue)]
        case .favoriteToggled(let symbol, let isFavorite):
            [.symbol: .text(symbol.rawValue), .isFavorite: .boolean(isFavorite)]
        case .quoteOpened(let symbol), .symbolAdded(let symbol):
            [.symbol: .text(symbol.rawValue)]
        }
    }
}

private extension WatchlistIssue {
    var analyticsValue: String {
        switch self {
        case .offline:
            "offline"
        case .serviceUnavailable:
            "service_unavailable"
        case .unreadableData:
            "unreadable_data"
        }
    }
}
