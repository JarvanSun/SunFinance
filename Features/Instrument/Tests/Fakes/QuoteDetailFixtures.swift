//
//  QuoteDetailFixtures.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

nonisolated let appleDetail = QuoteDetail(
    quote: StockQuote(
        symbol: "AAPL",
        companyName: "Apple Inc.",
        price: Money(110, .usd),
        changePercent: 10,
        marketCap: Money(3_450_000_000_000, .usd),
        isMarketOpen: true
    ),
    open: Money(100, .usd),
    dayRange: 99...111,
    yearRange: 80...120,
    volume: 1_234_567
)

nonisolated let appleDayHistory = PriceHistory(
    symbol: "AAPL",
    range: .day,
    currency: .usd,
    baseline: 100,
    candles: [
        PriceCandle(
            start: Date(timeIntervalSince1970: 0),
            open: 100,
            high: 106,
            low: 99,
            close: 105,
            volume: 10
        ),
        PriceCandle(
            start: Date(timeIntervalSince1970: 300),
            open: 105,
            high: 111,
            low: 104,
            close: 110,
            volume: 12
        ),
    ]
)
