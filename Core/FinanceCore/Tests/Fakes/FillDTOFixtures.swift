//
//  FillDTOFixtures.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

@testable import FinanceCore

extension FillDTO {
    static func make(currency: String = "USD") -> FillDTO {
        FillDTO(
            date: Date(timeIntervalSince1970: 1_000),
            quantity: 2,
            price: MoneyDTO(amount: 100, currency: currency),
            exchangeRate: 0.9,
            fee: .eur(1),
            total: .eur(181)
        )
    }
}
