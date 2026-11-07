//
//  WatchlistActivity.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum WatchlistActivity: Equatable, Sendable {
    case idle
    case loading
    case loaded
    case failed(WatchlistIssue)
}
