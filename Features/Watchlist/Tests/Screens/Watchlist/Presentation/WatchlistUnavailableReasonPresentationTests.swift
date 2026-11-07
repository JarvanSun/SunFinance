//
//  WatchlistUnavailableReasonPresentationTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

@testable import Watchlist

struct WatchlistUnavailableReasonPresentationTests {
    @Test(arguments: [
        (WatchlistUnavailableReason.empty, "watchlist.placeholder.empty.title"),
        (.noSearchResults(query: "Tesla"), "watchlist.placeholder.noResults.title"),
        (.failed(.offline), "watchlist.placeholder.offline.title"),
        (.failed(.serviceUnavailable), "watchlist.placeholder.unavailable.title"),
        (.failed(.unreadableData), "watchlist.placeholder.unreadable.title"),
    ])
    func titleThenNamesTheReason(reason: WatchlistUnavailableReason, key: String) {
        #expect(reason.title.key == key)
    }

    @Test(arguments: [
        (WatchlistUnavailableReason.empty, "watchlist.placeholder.empty.message"),
        (.noSearchResults(query: "Tesla"), "watchlist.placeholder.noResults.message %@"),
        (.failed(.offline), "watchlist.placeholder.offline.message"),
        (.failed(.serviceUnavailable), "watchlist.placeholder.unavailable.message"),
        (.failed(.unreadableData), "watchlist.placeholder.unreadable.message"),
    ])
    func messageThenExplainsTheReason(reason: WatchlistUnavailableReason, key: String) {
        #expect(reason.message.key == key)
    }

    @Test(arguments: [
        (WatchlistUnavailableReason.empty, FinanceImage.emptyWatchlist),
        (.noSearchResults(query: "Tesla"), .search),
        (.failed(.offline), .offline),
        (.failed(.serviceUnavailable), .warning),
        (.failed(.unreadableData), .warning),
    ])
    func imageThenMatchesTheReason(reason: WatchlistUnavailableReason, expected: FinanceImage) {
        #expect(reason.image == expected)
    }

    @Test(arguments: [
        (WatchlistUnavailableReason.empty, false),
        (.noSearchResults(query: "Tesla"), false),
        (.failed(.offline), true),
        (.failed(.unreadableData), true),
    ])
    func actionThenRetriesOnlyFailures(reason: WatchlistUnavailableReason, hasRetry: Bool) {
        // Given / When
        let action = reason.action(onRetry: {})

        // Then
        #expect((action != nil) == hasRetry)
    }

    @Test func actionWhenFailedThenCarriesRetryIdentifier() {
        // Given / When
        let action = WatchlistUnavailableReason.failed(.offline).action(onRetry: {})

        // Then
        #expect(action?.accessibilityIdentifier == WatchlistAccessibility.retryButton.rawValue)
    }
}
