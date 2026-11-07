//
//  ValuePointDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct ValuePointDTO: Codable, Sendable {
    let date: Date
    let value: MoneyDTO
}
