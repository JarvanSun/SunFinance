//
//  PortfolioFixtures.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

nonisolated let sampleAccount = Account(
    cash: Money(1_000, .eur),
    buyingPower: Money(1_000, .eur),
    positionsValue: Money(3_000, .eur),
    total: Money(4_000, .eur),
    todayGain: Money(100, .eur)
)

extension Position {
    nonisolated init(
        _ symbol: TickerSymbol,
        value: Decimal,
        totalReturn: Decimal,
        quantity: Decimal = 10
    ) {
        let euros = { (amount: Decimal) in Money(amount, .eur) }
        self.init(
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

nonisolated let samplePortfolio = Portfolio(
    open: [
        Position("SAP", value: 2_000, totalReturn: 200),
        Position("AAPL", value: 1_000, totalReturn: -50),
    ],
    closed: [Position("KO", value: 0, totalReturn: 30, quantity: 0)]
)

nonisolated let sampleHistory = PortfolioHistory(
    range: .month,
    points: [
        .init(date: Date(timeIntervalSince1970: 0), value: Money(3_000, .eur)),
        .init(date: Date(timeIntervalSince1970: 100), value: Money(3_300, .eur)),
        .init(date: Date(timeIntervalSince1970: 200), value: Money(4_000, .eur)),
    ]
)
