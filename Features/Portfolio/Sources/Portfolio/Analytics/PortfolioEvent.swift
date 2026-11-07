//
//  PortfolioEvent.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum PortfolioEvent: AnalyticsEvent, Equatable {
    case viewed(positionCount: Int)
    case rangeChanged(HistoryRange)
    case positionOpened(TickerSymbol)

    var name: AnalyticsEventName {
        switch self {
        case .viewed: .init("portfolio_viewed")
        case .rangeChanged: .init("portfolio_range_changed")
        case .positionOpened: .init("portfolio_position_opened")
        }
    }

    var parameters: [AnalyticsParameter: AnalyticsValue] {
        switch self {
        case .viewed(let count): [.positionCount: .integer(count)]
        case .rangeChanged(let range): [.range: .text(range.rawValue)]
        case .positionOpened(let symbol): [.symbol: .text(symbol.rawValue)]
        }
    }
}
