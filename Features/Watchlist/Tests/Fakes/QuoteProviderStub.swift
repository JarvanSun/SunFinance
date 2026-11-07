//
//  QuoteProviderStub.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

struct QuoteProviderStub: QuoteProviding {
    let result: Result<[StockQuote], MarketDataError>

    func quotes(for symbols: [TickerSymbol]) async throws(MarketDataError) -> [StockQuote] {
        try result.get()
    }
}
