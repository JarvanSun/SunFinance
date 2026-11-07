//
//  StockQuote.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct StockQuote: Identifiable, Hashable, Sendable {
    public let symbol: TickerSymbol
    public let companyName: String
    public let price: Money
    public let changePercent: Decimal
    public let marketCap: Money
    public let isMarketOpen: Bool

    public var id: TickerSymbol { symbol }

    var isGain: Bool { changePercent > 0 }

    var isLoss: Bool { changePercent < 0 }

    public init(
        symbol: TickerSymbol,
        companyName: String,
        price: Money,
        changePercent: Decimal,
        marketCap: Money,
        isMarketOpen: Bool = true
    ) {
        self.symbol = symbol
        self.companyName = companyName
        self.price = price
        self.changePercent = changePercent
        self.marketCap = marketCap
        self.isMarketOpen = isMarketOpen
    }
}

extension StockQuote {
    init(_ dto: QuoteDTO) throws(MarketDataError) {
        guard
            !dto.companyName.isEmpty,
            let currency = CurrencyCode(rawValue: dto.currency),
            dto.lastPrice > 0,
            dto.previousClose > 0
        else { throw .decoding }

        self.init(
            symbol: .init(rawValue: dto.symbol),
            companyName: dto.companyName,
            price: Money(dto.lastPrice, currency),
            changePercent: (dto.lastPrice / dto.previousClose - 1) * Self.percentScale,
            marketCap: Money(dto.marketCap, currency),
            isMarketOpen: dto.isMarketOpen
        )
    }
}

private extension StockQuote {
    static var percentScale: Decimal { 100 }
}
