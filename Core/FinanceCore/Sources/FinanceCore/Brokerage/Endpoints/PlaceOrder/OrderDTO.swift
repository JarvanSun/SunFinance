//
//  OrderDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct OrderDTO: Codable, Sendable {
    let id: String
    let draft: OrderDraftDTO
    let quantity: Decimal
    let currency: String
    let status: String
    let rejection: String?
    let createdAt: Date
    let fill: FillDTO?

    enum CodingKeys: String, CodingKey {
        case id
        case draft
        case quantity
        case currency
        case status
        case rejection
        case createdAt = "created_at"
        case fill
    }
}
