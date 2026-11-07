//
//  SymbolMatchFixtures.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

nonisolated let teslaMatch = SymbolMatch(
    symbol: "TSLA",
    companyName: "Tesla, Inc.",
    exchange: "NASDAQ",
    currency: .usd
)

nonisolated let appleMatch = SymbolMatch(
    symbol: "AAPL",
    companyName: "Apple Inc.",
    exchange: "NASDAQ",
    currency: .usd
)
