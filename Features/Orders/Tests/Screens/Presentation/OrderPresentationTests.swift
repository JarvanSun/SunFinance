//
//  OrderPresentationTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Orders

struct OrderPresentationTests {
    @Test(arguments: [
        (OrderAmount.shares(1), TradeSide.buy, "buy", "shares.buy %@ %lf"),
        (.shares(1), .sell, "sell", "shares.sell %@ %lf"),
        (.euros(500), .buy, "euros.buy", "euros.buy %@"),
        (.euros(500), .sell, "euros.sell", "euros.sell %@"),
    ])
    func headlineAndSubtitleThenFollowSideAndAmount(
        amount: OrderAmount,
        side: TradeSide,
        headline: String,
        subtitle: String
    ) {
        // When
        let order = Order.make("1", amount: amount, side: side)

        // Then
        #expect(order.headline.key == "orders.headline.\(headline) %@ %@")
        #expect(order.rowSubtitle.key == "orders.row.\(subtitle)")
    }

    @Test(arguments: [
        (OrderTrigger.immediately, "orders.trigger.now", "orders.execution.limit %@"),
        (.priceAtOrBelow(90), "orders.trigger.price %@", "orders.row.stop %@"),
        (.at(Date(timeIntervalSince1970: 0)), "orders.trigger.time %@", "orders.row.scheduled %@"),
    ])
    func triggerTextAndRowKindThenDescribeHowItGoesOut(
        trigger: OrderTrigger,
        triggerText: String,
        rowKind: String
    ) {
        // When
        let order = Order.make("1", trigger: trigger)

        // Then
        #expect(order.triggerText.key == triggerText)
        #expect(order.rowKind.key == rowKind)
        #expect(order.executionText.key == "orders.execution.limit %@")
        #expect(order.validityText.key == "orders.validity.gtc")
    }

    @Test func rowSubtitleThenCountsSharesInPlural() {
        // Given
        var subtitle = Order.make("1").rowSubtitle
        subtitle.locale = Locale(identifier: "en_US")

        // When
        let text = String(localized: subtitle)

        // Then
        #expect(text == "Buy · 1 share")
    }

    @Test(arguments: [
        (TradeSide.buy, Money(-93, .eur).formattedSigned()),
        (.sell, Money(93, .eur).formattedSigned()),
    ])
    func settledTotalThenIsSignedLikeTheCash(side: TradeSide, expected: String) {
        // When
        let order = Order.make("1", status: .filled, side: side, fill: .make(currency: .eur))

        // Then
        #expect(order.settledTotal == expected)
        #expect(Order.make("2").settledTotal == nil)
    }

    @Test func accessibilityLabelThenReadsTheRowAsOneSentence() {
        // Given
        var label = Order.make("1").accessibilityLabel
        label.locale = Locale(identifier: "en_US")

        // When
        let text = String(localized: label)

        // Then
        #expect(label.key == "orders.row.accessibilityLabel %@ %@ %@ %@")
        #expect(text.hasPrefix("SAP, Buy · 1 share, Limit "))
        #expect(text.hasSuffix(", Limit set"))
    }
}
