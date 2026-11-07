//
//  WatchlistRouterSpy.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

@testable import Watchlist

final class WatchlistRouterSpy: WatchlistRouting {
    private(set) var shownSymbols: [TickerSymbol] = []

    func showQuoteDetail(for symbol: TickerSymbol) {
        shownSymbols.append(symbol)
    }
}
