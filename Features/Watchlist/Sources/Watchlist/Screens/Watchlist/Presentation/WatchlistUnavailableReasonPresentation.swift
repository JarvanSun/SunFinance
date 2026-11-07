//
//  WatchlistUnavailableReasonPresentation.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

extension WatchlistUnavailableReason {
    var title: LocalizedStringResource {
        switch self {
        case .empty: .init("watchlist.placeholder.empty.title", bundle: .module)
        case .noSearchResults: .init("watchlist.placeholder.noResults.title", bundle: .module)
        case .failed(.offline): .init("watchlist.placeholder.offline.title", bundle: .module)
        case .failed(.serviceUnavailable):
            .init("watchlist.placeholder.unavailable.title", bundle: .module)
        case .failed(.unreadableData):
            .init("watchlist.placeholder.unreadable.title", bundle: .module)
        }
    }

    var message: LocalizedStringResource {
        switch self {
        case .empty: .init("watchlist.placeholder.empty.message", bundle: .module)
        case .noSearchResults(let query):
            .init("watchlist.placeholder.noResults.message \(query)", bundle: .module)
        case .failed(.offline): .init("watchlist.placeholder.offline.message", bundle: .module)
        case .failed(.serviceUnavailable):
            .init("watchlist.placeholder.unavailable.message", bundle: .module)
        case .failed(.unreadableData):
            .init("watchlist.placeholder.unreadable.message", bundle: .module)
        }
    }

    var image: FinanceImage {
        switch self {
        case .empty: .emptyWatchlist
        case .noSearchResults: .search
        case .failed(.offline): .offline
        case .failed(.serviceUnavailable), .failed(.unreadableData): .warning
        }
    }

    func action(onRetry: @escaping () -> Void) -> StateAction? {
        switch self {
        case .failed:
            StateAction(
                title: .init("watchlist.placeholder.retry", bundle: .module),
                accessibilityIdentifier: WatchlistAccessibility.retryButton,
                perform: onRetry
            )
        case .empty, .noSearchResults: nil
        }
    }
}
