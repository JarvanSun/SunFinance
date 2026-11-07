//
//  WatchlistSortOrder.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum WatchlistSortOrder: String, CaseIterable, Identifiable, Sendable {
    case marketCap
    case dailyChange
    case symbol

    var id: Self { self }

    var areInIncreasingOrder: (StockQuote, StockQuote) -> Bool {
        switch self {
        case .marketCap:
            { $0.marketCap.amount > $1.marketCap.amount }
        case .dailyChange:
            { $0.changePercent > $1.changePercent }
        case .symbol:
            { $0.symbol < $1.symbol }
        }
    }
}
