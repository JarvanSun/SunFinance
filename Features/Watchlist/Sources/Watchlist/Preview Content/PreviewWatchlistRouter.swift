//
//  PreviewWatchlistRouter.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore

final class PreviewWatchlistRouter: WatchlistRouting {
    func showQuoteDetail(for symbol: TickerSymbol) {}
}
#endif
