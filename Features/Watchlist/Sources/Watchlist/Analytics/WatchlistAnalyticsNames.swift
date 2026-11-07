//
//  WatchlistAnalyticsNames.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

extension AnalyticsEventName {
    static let watchlistViewed = Self("watchlist_viewed")
    static let watchlistQuotesLoaded = Self("watchlist_quotes_loaded")
    static let watchlistQuotesFailed = Self("watchlist_quotes_failed")
    static let watchlistSearchSubmitted = Self("watchlist_search_submitted")
    static let watchlistSortChanged = Self("watchlist_sort_changed")
    static let watchlistFavoriteToggled = Self("watchlist_favorite_toggled")
    static let watchlistQuoteOpened = Self("watchlist_quote_opened")
    static let watchlistSymbolAdded = Self("watchlist_symbol_added")
}
