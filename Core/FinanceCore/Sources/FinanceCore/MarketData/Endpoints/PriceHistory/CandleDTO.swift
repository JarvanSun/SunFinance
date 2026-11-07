//
//  CandleDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct CandleDTO: Codable, Sendable {
    let start: Date
    let open: Decimal
    let high: Decimal
    let low: Decimal
    let close: Decimal
    let volume: Int
}
