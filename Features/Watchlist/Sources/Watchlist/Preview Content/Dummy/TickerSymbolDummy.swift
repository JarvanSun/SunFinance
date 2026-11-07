//
//  TickerSymbolDummy.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore

extension TickerSymbol {
    static var dummyFavorites: Set<TickerSymbol> {
        ["AAPL"]
    }
}
#endif
