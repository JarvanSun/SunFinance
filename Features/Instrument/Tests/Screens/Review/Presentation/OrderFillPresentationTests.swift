//
//  OrderFillPresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct OrderFillPresentationTests {
    @Test(arguments: [
        (CurrencyCode.usd, ["quantity", "price", "rate", "fee"]),
        (.eur, ["quantity", "price", "fee"]),
    ])
    func rowsThenShowTheRateOnlyForAForeignStock(currency: CurrencyCode, ids: [String]) {
        // Given
        let fill = OrderFill(
            date: .testNow,
            quantity: 2,
            price: Money(200, currency),
            exchangeRate: 1,
            fee: Money(1, .eur),
            total: Money(401, .eur)
        )

        // When
        let rows = fill.rows

        // Then
        #expect(rows.map(\.id) == ids)
    }
}
