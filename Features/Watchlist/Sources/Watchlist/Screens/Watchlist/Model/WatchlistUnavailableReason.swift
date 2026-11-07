//
//  WatchlistUnavailableReason.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum WatchlistUnavailableReason: Equatable, Sendable {
    case empty
    case noSearchResults(query: String)
    case failed(WatchlistIssue)
}
