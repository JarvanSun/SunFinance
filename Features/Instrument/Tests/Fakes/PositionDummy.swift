//
//  PositionDummy.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension Position {
    nonisolated static func dummy(holding symbol: TickerSymbol, quantity: Decimal) -> Position {
        let zero = Money(0, .eur)
        return .init(
            symbol: symbol,
            quantity: quantity,
            price: Money(110, .usd),
            averageCost: zero,
            averageLocalCost: Money(0, .usd),
            costBasis: zero,
            marketValue: zero,
            unrealizedGain: zero,
            unrealizedGainPercent: 0,
            realizedGain: zero,
            todayGain: zero,
            currencyEffect: zero,
            totalReturn: zero,
            totalReturnPercent: 0
        )
    }

    nonisolated static var dummyEuroHolding: Position {
        .init(
            symbol: "SAP",
            quantity: 2,
            price: Money(200, .eur),
            averageCost: Money(210, .eur),
            averageLocalCost: Money(210, .eur),
            costBasis: Money(420, .eur),
            marketValue: Money(400, .eur),
            unrealizedGain: Money(-20, .eur),
            unrealizedGainPercent: -4.76,
            realizedGain: Money(0, .eur),
            todayGain: Money(2, .eur),
            currencyEffect: Money(0, .eur),
            totalReturn: Money(-20, .eur),
            totalReturnPercent: -4.76
        )
    }
}
