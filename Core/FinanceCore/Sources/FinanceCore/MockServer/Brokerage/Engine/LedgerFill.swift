//
//  LedgerFill.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct LedgerFill: Codable, Equatable, Sendable {
    let id: String
    let orderID: Order.ID
    let symbol: TickerSymbol
    let side: TradeSide
    let quantity: Decimal
    let price: Decimal
    let currency: CurrencyCode
    let exchangeRate: Decimal
    let fee: Decimal
    let date: Date

    var grossInEuros: Decimal {
        quantity * price * exchangeRate
    }

    var priceInEuros: Decimal {
        price * exchangeRate
    }

    var cashEffect: Decimal {
        side.cashEffect(gross: grossInEuros, fee: fee)
    }

    var total: Decimal {
        side.total(ofCashEffect: cashEffect)
    }
}
