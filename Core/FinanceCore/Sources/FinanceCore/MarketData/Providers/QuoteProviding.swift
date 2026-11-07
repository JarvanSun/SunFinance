//
//  QuoteProviding.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public protocol QuoteProviding: Sendable {
    func quotes(for symbols: [TickerSymbol]) async throws(MarketDataError) -> [StockQuote]
}
