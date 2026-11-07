//
//  WatchlistSymbolStoreSpy.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

final class WatchlistSymbolStoreSpy: WatchlistSymbolStoring {
    let symbols: [TickerSymbol]

    private(set) var savedSymbols: [[TickerSymbol]] = []

    init(symbols: [TickerSymbol] = ["AAPL", "SAP"]) {
        self.symbols = symbols
    }

    func save(_ symbols: [TickerSymbol]) {
        savedSymbols.append(symbols)
    }
}
