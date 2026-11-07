//
//  WatchlistPlaceholderPresentationTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import Watchlist

struct WatchlistPlaceholderPresentationTests {
    @Test(arguments: [
        (WatchlistPlaceholder.loading, "watchlist.placeholder.loading.title"),
        (.searching, "watchlist.placeholder.searching.title"),
        (.unavailable(.empty), "watchlist.placeholder.empty.title"),
        (.unavailable(.failed(.offline)), "watchlist.placeholder.offline.title"),
    ])
    func titleThenNamesThePlaceholder(placeholder: WatchlistPlaceholder, key: String) {
        // Then
        #expect(placeholder.title.key == key)
    }
}
