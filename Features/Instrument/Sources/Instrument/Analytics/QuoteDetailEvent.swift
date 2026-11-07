//
//  QuoteDetailEvent.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum QuoteDetailEvent: AnalyticsEvent, Equatable {
    case screenViewed(symbol: TickerSymbol)
    case rangeChanged(symbol: TickerSymbol, range: HistoryRange)
    case chartStyleChanged(ChartStyle)
    case chartScrubbed(symbol: TickerSymbol, range: HistoryRange)

    var name: AnalyticsEventName {
        switch self {
        case .screenViewed:
            .quoteDetailViewed
        case .rangeChanged:
            .quoteDetailRangeChanged
        case .chartStyleChanged:
            .quoteDetailChartStyleChanged
        case .chartScrubbed:
            .quoteDetailChartScrubbed
        }
    }

    var parameters: [AnalyticsParameter: AnalyticsValue] {
        switch self {
        case .screenViewed(let symbol):
            [.symbol: .text(symbol.rawValue)]
        case .rangeChanged(let symbol, let range), .chartScrubbed(let symbol, let range):
            [.symbol: .text(symbol.rawValue), .range: .text(range.rawValue)]
        case .chartStyleChanged(let style):
            [.chartStyle: .text(style.rawValue)]
        }
    }
}
