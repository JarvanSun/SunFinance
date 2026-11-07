//
//  QuoteDetailProviding.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public protocol QuoteDetailProviding: Sendable {
    func quoteDetail(for symbol: TickerSymbol) async throws(MarketDataError) -> QuoteDetail
}
