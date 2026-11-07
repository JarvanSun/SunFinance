//
//  WatchlistSortOrderPresentationTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import Watchlist

struct WatchlistSortOrderPresentationTests {
    @Test func titleThenEveryOrderHasItsOwnKey() {
        // Given / When
        let keys = WatchlistSortOrder.allCases.map(\.title.key)

        // Then
        #expect(Set(keys).count == WatchlistSortOrder.allCases.count)
    }
}
