//
//  PositionBook.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct PositionBook: Equatable, Sendable {
    let fills: [LedgerFill]

    init(fills: [LedgerFill]) {
        self.fills = fills.sorted { $0.date < $1.date }
    }

    func holdings(asOf date: Date) -> [Holding] {
        fills
            .filter { $0.date <= date }
            .reduce(into: [TickerSymbol: Holding]()) { holdings, fill in
                var holding =
                    holdings[fill.symbol] ?? Holding(symbol: fill.symbol, currency: fill.currency)
                holding.apply(fill)
                holdings[fill.symbol] = holding
            }
            .values
            .sorted { $0.symbol < $1.symbol }
    }

    func holding(of symbol: TickerSymbol, asOf date: Date) -> Holding? {
        holdings(asOf: date).first { $0.symbol == symbol }
    }

    func fills(of symbol: TickerSymbol, after date: Date) -> [LedgerFill] {
        fills.filter { $0.symbol == symbol && $0.date > date }
    }
}
