//
//  PlaygroundEvent.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum PlaygroundEvent: String, CaseIterable, Identifiable, AnalyticsEvent {
    case screenViewed
    case quoteOpened
    case searchWithQueryText

    var id: Self { self }

    var name: AnalyticsEventName {
        switch self {
        case .screenViewed:
            AnalyticsEventName("playground_viewed")
        case .quoteOpened:
            AnalyticsEventName("playground_quote_opened")
        case .searchWithQueryText:
            AnalyticsEventName("playground_search_submitted")
        }
    }

    var parameters: [AnalyticsParameter: AnalyticsValue] {
        switch self {
        case .screenViewed:
            [:]
        case .quoteOpened:
            [.symbol: .text("AAPL")]
        case .searchWithQueryText:
            [.query: .text("apple")]
        }
    }
}
