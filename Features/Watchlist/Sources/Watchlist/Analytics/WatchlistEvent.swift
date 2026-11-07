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
            .init("watchlist_viewed")
        case .quotesLoaded:
            .init("watchlist_quotes_loaded")
        case .quotesFailed:
            .init("watchlist_quotes_failed")
        case .searchSubmitted:
            .init("watchlist_search_submitted")
        case .sortOrderChanged:
            .init("watchlist_sort_changed")
        case .favoriteToggled:
            .init("watchlist_favorite_toggled")
        case .quoteOpened:
            .init("watchlist_quote_opened")
        case .symbolAdded:
            .init("watchlist_symbol_added")
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
