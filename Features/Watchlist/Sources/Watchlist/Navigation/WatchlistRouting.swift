//
//  WatchlistRouting.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

protocol WatchlistRouting: AnyObject {
    func showQuoteDetail(for symbol: TickerSymbol)
}
