//
//  MockListing.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct MockListing: Decodable, Sendable {
    let symbol: TickerSymbol
    let currency: CurrencyCode
    let venue: TradingVenue
    let referencePrice: Decimal
    let volatility: Double

    enum CodingKeys: String, CodingKey {
        case symbol
        case currency
        case venue
        case referencePrice = "reference_price"
        case volatility
    }
}
