//
//  CompanyDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct CompanyDTO: Decodable, Sendable {
    let symbol: TickerSymbol
    let companyName: String
    let marketCap: Decimal

    enum CodingKeys: String, CodingKey {
        case symbol
        case companyName = "company_name"
        case marketCap = "market_cap"
    }
}
