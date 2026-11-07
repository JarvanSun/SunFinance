//
//  OrderEstimate.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct OrderEstimate: Equatable, Sendable {
    let quantity: Decimal
    let price: Decimal
    let currency: CurrencyCode
    let rate: Decimal
    let fee: Decimal

    func cashEffect(for side: TradeSide) -> Decimal {
        side.cashEffect(gross: quantity * price * rate, fee: fee)
    }

    func total(for side: TradeSide) -> Decimal {
        side.total(ofCashEffect: cashEffect(for: side))
    }
}
