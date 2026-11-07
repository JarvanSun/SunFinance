//
//  PositionDummy.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension Position {
    nonisolated static func dummy(
        _ symbol: TickerSymbol,
        quantity: Decimal,
        value: Decimal,
        gain: Decimal
    ) -> Position {
        let cost = value - gain
        return .init(
            symbol: symbol,
            quantity: quantity,
            price: Money(value / max(quantity, 1), .eur),
            averageCost: Money(cost / max(quantity, 1), .eur),
            averageLocalCost: Money(cost / max(quantity, 1), .eur),
            costBasis: Money(cost, .eur),
            marketValue: Money(value, .eur),
            unrealizedGain: Money(gain, .eur),
            unrealizedGainPercent: cost == 0 ? 0 : gain / cost * 100,
            realizedGain: Money(quantity == 0 ? gain : 0, .eur),
            todayGain: Money(gain / 20, .eur),
            currencyEffect: Money(0, .eur),
            totalReturn: Money(gain, .eur),
            totalReturnPercent: cost == 0 ? 0 : gain / cost * 100
        )
    }
}
#endif
