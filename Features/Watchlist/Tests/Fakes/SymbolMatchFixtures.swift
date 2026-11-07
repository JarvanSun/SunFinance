//
//  SymbolMatchFixtures.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

extension TickerSymbol {
    nonisolated static let tesla: Self = "TSLA"
}

extension SymbolMatch {
    nonisolated static let tesla = Self(
        symbol: .tesla,
        companyName: "Tesla, Inc.",
        exchange: "NASDAQ",
        currency: .usd
    )

    nonisolated static let apple = Self(
        symbol: .apple,
        companyName: "Apple Inc.",
        exchange: "NASDAQ",
        currency: .usd
    )
}
