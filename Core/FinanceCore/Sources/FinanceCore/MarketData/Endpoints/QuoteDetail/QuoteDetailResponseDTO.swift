//
//  QuoteDetailResponseDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct QuoteDetailResponseDTO: Codable, Sendable {
    let quote: QuoteDTO
    let open: Decimal
    let dayHigh: Decimal
    let dayLow: Decimal
    let yearHigh: Decimal
    let yearLow: Decimal
    let volume: Int

    enum CodingKeys: String, CodingKey {
        case quote
        case open
        case dayHigh = "day_high"
        case dayLow = "day_low"
        case yearHigh = "year_high"
        case yearLow = "year_low"
        case volume
    }
}
