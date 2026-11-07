//
//  PositionDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct PositionDTO: Codable, Sendable {
    let symbol: String
    let quantity: Decimal
    let price: MoneyDTO
    let averageCost: MoneyDTO
    let averageLocalCost: MoneyDTO
    let costBasis: MoneyDTO
    let marketValue: MoneyDTO
    let unrealizedGain: MoneyDTO
    let unrealizedGainPercent: Decimal
    let realizedGain: MoneyDTO
    let todayGain: MoneyDTO
    let currencyEffect: MoneyDTO
    let totalReturn: MoneyDTO
    let totalReturnPercent: Decimal

    enum CodingKeys: String, CodingKey {
        case symbol
        case quantity
        case price
        case averageCost = "average_cost"
        case averageLocalCost = "average_local_cost"
        case costBasis = "cost_basis"
        case marketValue = "market_value"
        case unrealizedGain = "unrealized_gain"
        case unrealizedGainPercent = "unrealized_gain_percent"
        case realizedGain = "realized_gain"
        case todayGain = "today_gain"
        case currencyEffect = "currency_effect"
        case totalReturn = "total_return"
        case totalReturnPercent = "total_return_percent"
    }
}
