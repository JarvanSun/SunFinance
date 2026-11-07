//
//  PortfolioDummy.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension Portfolio {
    nonisolated static func dummy(holdingApple quantity: Decimal) -> Portfolio {
        let zero = Money(0, .eur)
        let position = Position(
            symbol: "AAPL",
            quantity: quantity,
            price: Money(200, .usd),
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
        return .init(open: quantity > 0 ? [position] : [], closed: [])
    }
}
