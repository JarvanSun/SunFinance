//
//  ExchangeRate.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct ExchangeRate: Equatable, Sendable {
    let currency: CurrencyCode
    let eurosPerUnit: Decimal
}
