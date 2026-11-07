//
//  OrderPreviewPresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct OrderPreviewPresentationTests {
    @Test func rowsWhenStockTradesInDollarsThenShowsTheRate() {
        // Given / When
        let ids = OrderPreview.dummy(currency: .usd).rows(side: .buy).map(\.id)

        // Then
        #expect(ids == ["quantity", "price", "rate", "fee", "total", "cashAfter"])
    }

    @Test func rowsWhenStockTradesInEurosThenLeavesTheRateOut() {
        // Given / When
        let ids = OrderPreview.dummy(currency: .eur).rows(side: .sell).map(\.id)

        // Then
        #expect(ids == ["quantity", "price", "fee", "total", "cashAfter"])
    }

    @Test(arguments: [
        (TradeSide.buy, "trading.review.row.total.buy"),
        (.sell, "trading.review.row.total.sell"),
    ])
    func rowsThenEmphasizeTheTotalForTheSide(side: TradeSide, key: String) throws {
        // Given / When
        let total = try #require(OrderPreview.dummy().rows(side: side).first { $0.id == "total" })

        // Then
        #expect(total.title.key == key)
        #expect(total.emphasis == .total)
    }
}
