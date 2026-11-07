//
//  WatchlistPlaceholder.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum WatchlistPlaceholder: Equatable, Sendable {
    case loading
    case searching
    case unavailable(WatchlistUnavailableReason)
}
