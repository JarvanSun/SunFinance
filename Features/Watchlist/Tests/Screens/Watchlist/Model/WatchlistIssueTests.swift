//
//  WatchlistIssueTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Watchlist

struct WatchlistIssueTests {
    @Test(arguments: [
        (MarketDataError.offline, WatchlistIssue.offline),
        (.server(statusCode: 500), .serviceUnavailable),
        (.cancelled, .serviceUnavailable),
        (.decoding, .unreadableData),
    ])
    func initThenMapsEveryDomainError(error: MarketDataError, expected: WatchlistIssue) {
        // When
        let issue = WatchlistIssue(error)

        // Then
        #expect(issue == expected)
    }
}
