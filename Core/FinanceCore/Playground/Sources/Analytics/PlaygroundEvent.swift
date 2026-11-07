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
        case .screenViewed: .init("playground_viewed")
        case .quoteOpened: .init("playground_quote_opened")
        case .searchWithQueryText: .init("playground_search_submitted")
        }
    }

    var parameters: [AnalyticsParameter: AnalyticsValue] {
        switch self {
        case .screenViewed: [:]
        case .quoteOpened: [.symbol: .text("AAPL")]
        case .searchWithQueryText: [.query: .text("apple")]
        }
    }
}
