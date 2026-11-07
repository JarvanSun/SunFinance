//
//  OrderDetailPresentationTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Orders

struct OrderDetailPresentationTests {
    @Test func detailSectionsWhenOpenThenShowOnlyTheTerms() {
        // Given / When
        let sections = Order.dummy("1").detailSections

        // Then
        #expect(sections.map(\.id) == ["terms"])
        #expect(
            sections[0].rows.map(\.id) == ["placed", "type", "trigger", "validity", "quantity"]
        )
    }

    @Test(arguments: [
        (CurrencyCode.usd, ["filled", "price", "rate", "fee", "total"]),
        (.eur, ["filled", "price", "fee", "total"]),
    ])
    func detailSectionsWhenFilledThenAddTheFill(currency: CurrencyCode, ids: [String]) throws {
        // Given
        let order = Order.dummy("1", status: .filled, fill: .dummy(currency: currency))

        // When
        let fill = try #require(order.detailSections.last)

        // Then
        #expect(fill.id == "fill")
        #expect(fill.rows.map(\.id) == ids)
        #expect(fill.rows.last?.emphasis == .total)
    }

    @Test(arguments: [
        (TradeSide.buy, "orders.detail.row.total.buy"),
        (.sell, "orders.detail.row.total.sell"),
    ])
    func totalTitleThenFollowsTheSide(side: TradeSide, key: String) {
        #expect(Order.dummy("1", side: side).totalTitle.key == key)
    }
}
