//
//  FillDTODummy.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

@testable import FinanceCore

extension FillDTO {
    nonisolated static func dummy(currency: String = "USD") -> FillDTO {
        .init(
            date: Date(timeIntervalSince1970: 1_000),
            quantity: 2,
            price: MoneyDTO(amount: 100, currency: currency),
            exchangeRate: 0.9,
            fee: .init(euros: 1),
            total: .init(euros: 181)
        )
    }
}
