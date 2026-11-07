//
//  StockQuoteFixtures.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

nonisolated let appleQuote = StockQuote(
    symbol: "AAPL",
    companyName: "Apple Inc.",
    price: Money(228.52, .usd),
    changePercent: 1.24,
    marketCap: Money(3_450_000_000_000, .usd)
)

nonisolated let sapQuote = StockQuote(
    symbol: "SAP",
    companyName: "SAP SE",
    price: Money(221.35, .eur),
    changePercent: -0.38,
    marketCap: Money(271_000_000_000, .eur)
)

nonisolated let unchangedQuote = StockQuote(
    symbol: "ALV",
    companyName: "Allianz SE",
    price: Money(289.90, .eur),
    changePercent: 0,
    marketCap: Money(113_000_000_000, .eur)
)
