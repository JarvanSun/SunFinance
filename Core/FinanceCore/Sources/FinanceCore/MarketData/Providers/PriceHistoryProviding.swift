//
//  PriceHistoryProviding.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public protocol PriceHistoryProviding: Sendable {
    func priceHistory(for symbol: TickerSymbol, range: HistoryRange) async throws(MarketDataError)
        -> PriceHistory
}
