//
//  TradingSnapshot.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

nonisolated struct TradingSnapshot: Equatable, Sendable {
    let position: Position?
    let orders: [Order]
}

extension TradingSnapshot {
    static var empty: Self {
        .init(position: nil, orders: [])
    }

    init(symbol: TickerSymbol, portfolio: Portfolio, orders: [Order]) {
        self.init(
            position: portfolio.position(of: symbol),
            orders: orders.filter { $0.draft.symbol == symbol }
        )
    }
}
