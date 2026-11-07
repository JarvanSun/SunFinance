//
//  Money.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct Money: Hashable, Codable, Sendable {
    public let amount: Decimal
    public let currency: CurrencyCode

    public init(_ amount: Decimal, _ currency: CurrencyCode) {
        self.amount = amount
        self.currency = currency
    }
}
