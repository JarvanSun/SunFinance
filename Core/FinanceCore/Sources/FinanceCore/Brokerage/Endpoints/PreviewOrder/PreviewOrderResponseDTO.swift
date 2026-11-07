//
//  PreviewOrderResponseDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct PreviewOrderResponseDTO: Codable, Sendable {
    let quantity: Decimal
    let price: MoneyDTO
    let exchangeRate: Decimal
    let fee: MoneyDTO
    let total: MoneyDTO
    let cashAfter: MoneyDTO
    let rejection: String?

    enum CodingKeys: String, CodingKey {
        case quantity
        case price
        case exchangeRate = "exchange_rate"
        case fee
        case total
        case cashAfter = "cash_after"
        case rejection
    }
}
