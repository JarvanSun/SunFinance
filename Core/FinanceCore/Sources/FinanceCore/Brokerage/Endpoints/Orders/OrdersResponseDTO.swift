//
//  OrdersResponseDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

struct OrdersResponseDTO: Codable, Sendable {
    let orders: [OrderDTO]
    let nextCursor: String?

    enum CodingKeys: String, CodingKey {
        case orders
        case nextCursor = "next_cursor"
    }
}
