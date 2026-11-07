//
//  SymbolMatch.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct SymbolMatch: Identifiable, Hashable, Sendable {
    public let symbol: TickerSymbol
    public let companyName: String
    public let exchange: String
    public let currency: CurrencyCode

    public var id: TickerSymbol { symbol }

    public init(
        symbol: TickerSymbol,
        companyName: String,
        exchange: String,
        currency: CurrencyCode
    ) {
        self.symbol = symbol
        self.companyName = companyName
        self.exchange = exchange
        self.currency = currency
    }
}

extension SymbolMatch {
    init(_ dto: SymbolMatchDTO) throws(MarketDataError) {
        guard
            !dto.companyName.isEmpty,
            !dto.exchange.isEmpty,
            let currency = CurrencyCode(rawValue: dto.currency)
        else { throw .decoding }

        self.init(
            symbol: TickerSymbol(rawValue: dto.symbol),
            companyName: dto.companyName,
            exchange: dto.exchange,
            currency: currency
        )
    }
}
