//
//  PriceChange.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct PriceChange: Equatable, Sendable {
    let start: Money
    let end: Money

    var amount: Money {
        Money(end.amount - start.amount, end.currency)
    }

    var percent: Decimal {
        (end.amount - start.amount) / start.amount * percentScale
    }
}

private extension PriceChange {
    var percentScale: Decimal { 100 }
}
