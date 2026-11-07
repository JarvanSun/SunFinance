//
//  PriceHistoryResponseDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct PriceHistoryResponseDTO: Codable, Sendable {
    let symbol: String
    let range: String
    let currency: String
    let previousClose: Decimal?
    let candles: [CandleDTO]

    enum CodingKeys: String, CodingKey {
        case symbol
        case range
        case currency
        case previousClose = "previous_close"
        case candles
    }
}
