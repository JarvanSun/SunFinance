//
//  WatchlistDestination.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import SunUserInterface

nonisolated enum WatchlistDestination: FeatureDestination {
    case root
    case quoteDetail(TickerSymbol)
}
