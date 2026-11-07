//
//  OrderPreviewDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension OrderPreview {
    nonisolated static func dummy(rejection: OrderRejection?) -> OrderPreview {
        .init(
            quantity: 2,
            price: Money(231.42, .usd),
            exchangeRate: 0.9213,
            fee: Money(1, .eur),
            total: Money(427.42, .eur),
            cashAfter: Money(9_449.12, .eur),
            rejection: rejection
        )
    }
}
#endif
