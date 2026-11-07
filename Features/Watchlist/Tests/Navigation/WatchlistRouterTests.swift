//
//  WatchlistRouterTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SwiftUI
import Testing

@testable import Watchlist

struct WatchlistRouterTests {
    @Test func showQuoteDetailThenPushesDetailDestination() {
        // Given
        let router = WatchlistRouter(quoteDetail: FeatureEntry { _ in EmptyView() })

        // When
        router.showQuoteDetail(for: "SAP")

        // Then
        #expect(router.path == [.quoteDetail("SAP")])
        #expect(router.presentation == nil)
    }
}
