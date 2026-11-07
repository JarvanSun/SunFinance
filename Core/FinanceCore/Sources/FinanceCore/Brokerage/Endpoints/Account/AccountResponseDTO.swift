//
//  AccountResponseDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

struct AccountResponseDTO: Codable, Sendable {
    let cash: MoneyDTO
    let buyingPower: MoneyDTO
    let positionsValue: MoneyDTO
    let total: MoneyDTO
    let todayGain: MoneyDTO

    enum CodingKeys: String, CodingKey {
        case cash
        case buyingPower = "buying_power"
        case positionsValue = "positions_value"
        case total
        case todayGain = "today_gain"
    }
}
