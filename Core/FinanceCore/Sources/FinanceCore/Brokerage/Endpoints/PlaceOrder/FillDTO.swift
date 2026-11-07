//
//  FillDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct FillDTO: Codable, Sendable {
    let date: Date
    let quantity: Decimal
    let price: MoneyDTO
    let exchangeRate: Decimal
    let fee: MoneyDTO
    let total: MoneyDTO

    enum CodingKeys: String, CodingKey {
        case date
        case quantity
        case price
        case exchangeRate = "exchange_rate"
        case fee
        case total
    }
}
