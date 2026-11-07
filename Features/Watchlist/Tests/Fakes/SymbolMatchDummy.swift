//
//  SymbolMatchDummy.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

extension SymbolMatch {
    nonisolated static var dummyTesla: SymbolMatch {
        .init(symbol: "TSLA", companyName: "Tesla, Inc.", exchange: "NASDAQ", currency: .usd)
    }

    nonisolated static var dummyApple: SymbolMatch {
        .init(symbol: "AAPL", companyName: "Apple Inc.", exchange: "NASDAQ", currency: .usd)
    }
}
