//
//  QuoteDetail.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct QuoteDetail: Hashable, Sendable {
    public let quote: StockQuote
    public let open: Money
    public let dayRange: ClosedRange<Decimal>
    public let yearRange: ClosedRange<Decimal>
    public let volume: Int

    public init(
        quote: StockQuote,
        open: Money,
        dayRange: ClosedRange<Decimal>,
        yearRange: ClosedRange<Decimal>,
        volume: Int
    ) {
        self.quote = quote
        self.open = open
        self.dayRange = dayRange
        self.yearRange = yearRange
        self.volume = volume
    }
}

extension QuoteDetail {
    init(_ dto: QuoteDetailResponseDTO) throws(MarketDataError) {
        let quote = try StockQuote(dto.quote)
        guard dto.dayLow <= dto.dayHigh, dto.yearLow <= dto.yearHigh else { throw .decoding }

        self.init(
            quote: quote,
            open: Money(dto.open, quote.price.currency),
            dayRange: dto.dayLow...dto.dayHigh,
            yearRange: dto.yearLow...dto.yearHigh,
            volume: dto.volume
        )
    }
}
