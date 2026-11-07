//
//  StockQuoteDummy.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension StockQuote {
    nonisolated static var dummyApple: StockQuote {
        .init(
            symbol: "AAPL",
            companyName: "Apple Inc.",
            price: Money(200, .usd),
            changePercent: 1,
            marketCap: Money(1, .usd)
        )
    }
}
