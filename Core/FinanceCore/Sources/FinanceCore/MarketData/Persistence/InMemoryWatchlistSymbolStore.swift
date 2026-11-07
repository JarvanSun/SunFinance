//
//  InMemoryWatchlistSymbolStore.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public final class InMemoryWatchlistSymbolStore: WatchlistSymbolStoring {
    public private(set) var symbols: [TickerSymbol]

    public init(symbols: [TickerSymbol] = []) {
        self.symbols = symbols
    }

    public func save(_ symbols: [TickerSymbol]) {
        self.symbols = symbols
    }
}
