//
//  OrderPreviewDummy.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension OrderPreview {
    nonisolated static func dummy(
        rejection: OrderRejection? = nil,
        currency: CurrencyCode = .usd
    ) -> OrderPreview {
        .init(
            quantity: 2,
            price: Money(200, currency),
            exchangeRate: currency == .eur ? 1 : Decimal(string: "0.92")!,
            fee: Money(1, .eur),
            total: Money(369, .eur),
            cashAfter: Money(631, .eur),
            rejection: rejection
        )
    }
}
