//
//  PortfolioFixtures.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension Account {
    nonisolated static var sample: Account {
        Account(
            cash: Money(1_000, .eur),
            buyingPower: Money(1_000, .eur),
            positionsValue: Money(3_000, .eur),
            total: Money(4_000, .eur),
            todayGain: Money(100, .eur)
        )
    }
}

extension Position {
    nonisolated static func make(
        _ symbol: TickerSymbol,
        value: Decimal,
        totalReturn: Decimal,
        quantity: Decimal = 10
    ) -> Position {
        let euros = { (amount: Decimal) in Money(amount, .eur) }
        return Position(
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

extension Portfolio {
    nonisolated static var sample: Portfolio {
        Portfolio(
            open: [
                .make("SAP", value: 2_000, totalReturn: 200),
                .make("AAPL", value: 1_000, totalReturn: -50),
            ],
            closed: [.make("KO", value: 0, totalReturn: 30, quantity: 0)]
        )
    }
}

extension PortfolioHistory {
    nonisolated static var sample: PortfolioHistory {
        PortfolioHistory(
            range: .month,
            points: [
                .init(date: Date(timeIntervalSince1970: 0), value: Money(3_000, .eur)),
                .init(date: Date(timeIntervalSince1970: 100), value: Money(3_300, .eur)),
                .init(date: Date(timeIntervalSince1970: 200), value: Money(4_000, .eur)),
            ]
        )
    }
}
