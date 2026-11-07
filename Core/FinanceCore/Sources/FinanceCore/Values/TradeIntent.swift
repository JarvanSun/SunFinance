//
//  TradeIntent.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct TradeIntent: Identifiable, Hashable, Sendable {
    public let symbol: TickerSymbol
    public let side: TradeSide
    public let source: TradeSource

    public var id: String {
        "\(symbol.rawValue)-\(side.rawValue)"
    }

    public init(symbol: TickerSymbol, side: TradeSide, source: TradeSource) {
        self.symbol = symbol
        self.side = side
        self.source = source
    }
}
