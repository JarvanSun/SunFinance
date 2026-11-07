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

    init(position: Position? = nil, orders: [Order] = []) {
        self.position = position
        self.orders = orders
    }
}

extension TradingSnapshot {
    init(symbol: TickerSymbol, portfolio: Portfolio, orders: [Order]) {
        self.init(
            position: portfolio.position(of: symbol),
            orders: orders.filter { $0.draft.symbol == symbol }
        )
    }
}
