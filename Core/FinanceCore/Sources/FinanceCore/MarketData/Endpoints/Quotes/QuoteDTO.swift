//
//  QuoteDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct QuoteDTO: Codable, Sendable {
    let symbol: String
    let companyName: String
    let lastPrice: Decimal
    let currency: String
    let previousClose: Decimal
    let marketCap: Decimal
    let isMarketOpen: Bool

    enum CodingKeys: String, CodingKey {
        case symbol
        case companyName = "company_name"
        case lastPrice = "last_price"
        case currency
        case previousClose = "previous_close"
        case marketCap = "market_cap"
        case isMarketOpen = "is_market_open"
    }
}
