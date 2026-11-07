//
//  TickerSymbolDummy.swift
//  WatchlistPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

extension TickerSymbol {
    static var dummyWatchlist: [TickerSymbol] {
        ["AAPL", "SAP"]
    }

    static var dummyFavorites: Set<TickerSymbol> {
        ["AAPL"]
    }
}
