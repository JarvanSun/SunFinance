//
//  PositionDTODummy.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

@testable import FinanceCore

extension PositionDTO {
    nonisolated static func dummy(
        symbol: String = "AAPL",
        currency: String = "USD"
    ) -> PositionDTO {
        .init(
            symbol: symbol,
            quantity: 10,
            price: MoneyDTO(amount: 110, currency: currency),
            averageCost: .init(euros: 91),
            averageLocalCost: MoneyDTO(amount: 100, currency: currency),
            costBasis: .init(euros: 910),
            marketValue: .init(euros: 990),
            unrealizedGain: .init(euros: 80),
            unrealizedGainPercent: 8.79,
            realizedGain: .init(euros: 12),
            todayGain: .init(euros: -3),
            currencyEffect: .init(euros: -20),
            totalReturn: .init(euros: 92),
            totalReturnPercent: 9.2
        )
    }
}
