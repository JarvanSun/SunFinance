//
//  MockListingsDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct MockListingsDTO: Decodable, Sendable {
    let listings: [MockListing]
    let eurPerUSD: Decimal

    enum CodingKeys: String, CodingKey {
        case listings
        case eurPerUSD = "eur_per_usd"
    }
}
