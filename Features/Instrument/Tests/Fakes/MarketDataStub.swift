//
//  MarketDataStub.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Synchronization

final class MarketDataStub: QuoteDetailProviding, PriceHistoryProviding {
    private let detailResult: Result<QuoteDetail, MarketDataError>
    private let failing = Mutex<Set<HistoryRange>>([])

    var failingRanges: Set<HistoryRange> {
        get { failing.withLock { $0 } }
        set { failing.withLock { $0 = newValue } }
    }

    init(
        detailResult: Result<QuoteDetail, MarketDataError> = .success(appleDetail),
        failingRanges: Set<HistoryRange> = []
    ) {
        self.detailResult = detailResult
        failing.withLock { $0 = failingRanges }
    }

    func quoteDetail(for symbol: TickerSymbol) async throws(MarketDataError) -> QuoteDetail {
        try detailResult.get()
    }

    func priceHistory(for symbol: TickerSymbol, range: HistoryRange) async throws(MarketDataError)
        -> PriceHistory
    {
        guard !failingRanges.contains(range) else { throw .server(statusCode: 503) }

        let history = appleDayHistory
        return PriceHistory(
            symbol: history.symbol,
            range: range,
            currency: history.currency,
            baseline: history.baseline,
            candles: history.candles
        )
    }
}
