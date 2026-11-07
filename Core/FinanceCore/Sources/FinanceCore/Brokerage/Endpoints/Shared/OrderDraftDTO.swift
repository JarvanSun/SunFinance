//
//  OrderDraftDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct OrderDraftDTO: Codable, Sendable {
    let symbol: String
    let side: String
    let shares: Decimal?
    let cashAmount: Decimal?
    let execution: String
    let limitPrice: Decimal?
    let trigger: String
    let triggerPrice: Decimal?
    let triggerTime: Date?
    let validity: String

    enum CodingKeys: String, CodingKey {
        case symbol
        case side
        case shares
        case cashAmount = "cash_amount"
        case execution
        case limitPrice = "limit_price"
        case trigger
        case triggerPrice = "trigger_price"
        case triggerTime = "trigger_time"
        case validity
    }
}
