//
//  PreviewQuoteProvider.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore

struct PreviewQuoteProvider: QuoteProviding {
    let result: Result<[StockQuote], MarketDataError>
    let delay: Duration

    func quotes(for symbols: [TickerSymbol]) async throws(MarketDataError) -> [StockQuote] {
        try? await Task.sleep(for: delay)
        return try result.get()
    }
}
#endif
