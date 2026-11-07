//
//  LedgerFillDummy.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

@testable import FinanceCore

extension LedgerFill {
    nonisolated static func dummy(
        _ side: TradeSide,
        _ quantity: Decimal,
        at price: Decimal,
        rate: Decimal = 1,
        fee: Decimal = 1,
        symbol: TickerSymbol = "SAP",
        currency: CurrencyCode = .eur,
        day: Double = 0,
        date: Date? = nil
    ) -> LedgerFill {
        .init(
            id: UUID().uuidString,
            orderID: UUID().uuidString,
            symbol: symbol,
            side: side,
            quantity: quantity,
            price: price,
            currency: currency,
            exchangeRate: rate,
            fee: fee,
            date: date ?? Date(timeIntervalSince1970: 1_790_000_000 + day * 86_400)
        )
    }
}
