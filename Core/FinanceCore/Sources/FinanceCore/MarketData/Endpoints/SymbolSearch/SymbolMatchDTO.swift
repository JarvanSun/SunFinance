//
//  SymbolMatchDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

struct SymbolMatchDTO: Codable, Sendable {
    let symbol: String
    let companyName: String
    let exchange: String
    let currency: String

    enum CodingKeys: String, CodingKey {
        case symbol
        case companyName = "company_name"
        case exchange
        case currency
    }
}
