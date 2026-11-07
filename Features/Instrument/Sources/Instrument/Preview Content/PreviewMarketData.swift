//
//  PreviewMarketData.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

struct PreviewMarketData: QuoteDetailProviding, PriceHistoryProviding {
    let detailError: MarketDataError?
    let historyError: MarketDataError?
    let delay: Duration

    func quoteDetail(for symbol: TickerSymbol) async throws(MarketDataError) -> QuoteDetail {
        try? await Task.sleep(for: delay)
        try fail(with: detailError)
        return .dummy
    }

    func priceHistory(for symbol: TickerSymbol, range: HistoryRange) async throws(MarketDataError)
        -> PriceHistory
    {
        try? await Task.sleep(for: delay)
        try fail(with: historyError)
        return .dummy(range: range)
    }

    private func fail(with error: MarketDataError?) throws(MarketDataError) {
        guard let error else { return }

        throw error
    }
}
#endif
