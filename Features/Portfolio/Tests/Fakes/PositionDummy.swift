//
//  PositionDummy.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension Position {
    nonisolated static func dummy(
        _ symbol: TickerSymbol,
        value: Decimal,
        totalReturn: Decimal,
        quantity: Decimal = 10
    ) -> Position {
        let euros = { (amount: Decimal) in Money(amount, .eur) }
        return .init(
            symbol: symbol,
            quantity: quantity,
            price: euros(value / max(quantity, 1)),
            averageCost: euros(10),
            averageLocalCost: euros(10),
            costBasis: euros(value - totalReturn),
            marketValue: euros(value),
            unrealizedGain: euros(totalReturn),
            unrealizedGainPercent: 0,
            realizedGain: euros(0),
            todayGain: euros(0),
            currencyEffect: euros(0),
            totalReturn: euros(totalReturn),
            totalReturnPercent: 0
        )
    }
}
