//
//  QuoteDetailDummy.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension QuoteDetail {
    nonisolated static var dummyApple: QuoteDetail {
        .init(
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
    }
}
