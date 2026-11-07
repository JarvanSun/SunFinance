//
//  PositionDTOFixtures.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

@testable import FinanceCore

extension PositionDTO {
    static func make(symbol: String = "AAPL", currency: String = "USD") -> PositionDTO {
        PositionDTO(
            symbol: symbol,
            quantity: 10,
            price: MoneyDTO(amount: 110, currency: currency),
            averageCost: .eur(91),
            averageLocalCost: MoneyDTO(amount: 100, currency: currency),
            costBasis: .eur(910),
            marketValue: .eur(990),
            unrealizedGain: .eur(80),
            unrealizedGainPercent: 8.79,
            realizedGain: .eur(12),
            todayGain: .eur(-3),
            currencyEffect: .eur(-20),
            totalReturn: .eur(92),
            totalReturnPercent: 9.2
        )
    }
}
