//
//  TestEvent.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

@testable import FinanceCore

enum TestEvent: AnalyticsEvent {
    case favoriteToggled
    case searchWithQuery

    var name: AnalyticsEventName {
        switch self {
        case .favoriteToggled: .init("test_favorite_toggled")
        case .searchWithQuery: .init("test_search_submitted")
        }
    }

    var parameters: [AnalyticsParameter: AnalyticsValue] {
        switch self {
        case .favoriteToggled: [.symbol: .text("AAPL"), .isFavorite: .boolean(true)]
        case .searchWithQuery: [.query: .text("apple")]
        }
    }
}
