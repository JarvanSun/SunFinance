//
//  StockQuoteDummy.swift
//  WatchlistTests
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
            price: Money(228.52, .usd),
            changePercent: 1.24,
            marketCap: Money(3_450_000_000_000, .usd)
        )
    }

    nonisolated static var dummySAP: StockQuote {
        .init(
            symbol: "SAP",
            companyName: "SAP SE",
            price: Money(221.35, .eur),
            changePercent: -0.38,
            marketCap: Money(271_000_000_000, .eur)
        )
    }

    nonisolated static var dummyUnchanged: StockQuote {
        .init(
            symbol: "ALV",
            companyName: "Allianz SE",
            price: Money(289.90, .eur),
            changePercent: 0,
            marketCap: Money(113_000_000_000, .eur)
        )
    }
}
