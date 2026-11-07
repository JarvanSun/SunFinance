//
//  TradeAction.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

struct TradeAction: Identifiable, Equatable, Sendable {
    let side: TradeSide
    let price: Money

    var id: TradeSide { side }
}
