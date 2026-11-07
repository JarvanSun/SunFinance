//
//  PositionDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension Position {
    nonisolated static var dummy: Position {
        .init(
            symbol: "AAPL",
            quantity: 15,
            price: Money(231.42, .usd),
            averageCost: Money(182.1, .eur),
            averageLocalCost: Money(196.4, .usd),
            costBasis: Money(2_731.5, .eur),
            marketValue: Money(3_197.66, .eur),
            unrealizedGain: Money(466.16, .eur),
            unrealizedGainPercent: 17.07,
            realizedGain: Money(0, .eur),
            todayGain: Money(39.5, .eur),
            currencyEffect: Money(-41.3, .eur),
            totalReturn: Money(466.16, .eur),
            totalReturnPercent: 17.07
        )
    }

    static var dummyEuro: Position {
        .init(
            symbol: "SAP",
            quantity: 4.5,
            price: Money(221.35, .eur),
            averageCost: Money(230.1, .eur),
            averageLocalCost: Money(230.1, .eur),
            costBasis: Money(1_035.45, .eur),
            marketValue: Money(996.08, .eur),
            unrealizedGain: Money(-39.37, .eur),
            unrealizedGainPercent: -3.8,
            realizedGain: Money(12.4, .eur),
            todayGain: Money(-3.78, .eur),
            currencyEffect: Money(0, .eur),
            totalReturn: Money(-26.97, .eur),
            totalReturnPercent: -2.6
        )
    }
}
#endif
