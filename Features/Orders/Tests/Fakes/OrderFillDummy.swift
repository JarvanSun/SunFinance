//
//  OrderFillDummy.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension OrderFill {
    nonisolated static func dummy(currency: CurrencyCode) -> OrderFill {
        .init(
            date: Date(timeIntervalSince1970: 0),
            quantity: 1,
            price: Money(100, currency),
            exchangeRate: Decimal(string: "0.92")!,
            fee: Money(1, .eur),
            total: Money(93, .eur)
        )
    }
}
