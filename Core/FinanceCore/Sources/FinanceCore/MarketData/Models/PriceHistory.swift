//
//  PriceHistory.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct PriceHistory: Hashable, Sendable {
    public let symbol: TickerSymbol
    public let range: HistoryRange
    public let currency: CurrencyCode
    public let baseline: Decimal?
    public let candles: [PriceCandle]

    public init(
        symbol: TickerSymbol,
        range: HistoryRange,
        currency: CurrencyCode,
        baseline: Decimal?,
        candles: [PriceCandle]
    ) {
        self.symbol = symbol
        self.range = range
        self.currency = currency
        self.baseline = baseline
        self.candles = candles
    }
}

extension PriceHistory {
    init(_ dto: PriceHistoryResponseDTO) throws(MarketDataError) {
        guard
            let currency = CurrencyCode(rawValue: dto.currency),
            let range = HistoryRange(rawValue: dto.range)
        else { throw .decoding }

        self.init(
            symbol: TickerSymbol(rawValue: dto.symbol),
            range: range,
            currency: currency,
            baseline: dto.previousClose ?? dto.candles.first?.open,
            candles: dto.candles.map(PriceCandle.init(_:))
        )
    }
}
