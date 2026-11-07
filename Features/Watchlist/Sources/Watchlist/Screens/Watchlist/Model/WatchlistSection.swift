//
//  WatchlistSection.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum WatchlistSection: Hashable, Identifiable, Sendable {
    case quotes
    case quotesMatchingSearch
    case symbolMatches

    var id: Self { self }
}
