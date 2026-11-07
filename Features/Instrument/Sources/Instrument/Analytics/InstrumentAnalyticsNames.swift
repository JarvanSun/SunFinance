//
//  InstrumentAnalyticsNames.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

extension AnalyticsEventName {
    static let quoteDetailViewed = Self("quote_detail_viewed")
    static let quoteDetailRangeChanged = Self("quote_detail_range_changed")
    static let quoteDetailChartStyleChanged = Self("quote_detail_chart_style_changed")
    static let quoteDetailChartScrubbed = Self("quote_detail_chart_scrubbed")
    static let tradingTicketOpened = Self("trading_ticket_opened")
    static let tradingOrderReviewed = Self("trading_order_reviewed")
    static let tradingOrderPlaced = Self("trading_order_placed")
    static let tradingOrderFailed = Self("trading_order_failed")
}
