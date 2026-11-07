//
//  MoneyDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct MoneyDTO: Codable, Sendable {
    let amount: Decimal
    let currency: String
}

extension MoneyDTO {
    init(_ money: Money) {
        self.init(amount: money.amount, currency: money.currency.rawValue)
    }

    init(euros amount: Decimal) {
        self.init(amount: amount, currency: CurrencyCode.eur.rawValue)
    }
}

extension MoneyDTO {
    func money() throws(BrokerageError) -> Money {
        guard let currency = CurrencyCode(rawValue: currency) else { throw .decoding }

        return .init(amount, currency)
    }
}
