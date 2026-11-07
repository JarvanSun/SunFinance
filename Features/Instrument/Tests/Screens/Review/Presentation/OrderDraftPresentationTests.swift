//
//  OrderDraftPresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct OrderDraftPresentationTests {
    @Test(arguments: [
        (OrderDraft.dummy(.buy, amount: .shares(2)), "trading.review.summary.buy %@ %@"),
        (.dummy(.sell, amount: .shares(2)), "trading.review.summary.sell %@ %@"),
        (.dummy(.buy, amount: .euros(500)), "trading.review.summary.euros.buy %@ %@"),
        (.dummy(.sell, amount: .euros(500)), "trading.review.summary.euros.sell %@ %@"),
    ])
    func headlineThenFollowsSideAndAmount(draft: OrderDraft, key: String) {
        #expect(draft.headline.key == key)
    }

    @Test(arguments: [
        (
            OrderDraft.dummy(),
            "trading.review.execution.market",
            "trading.review.trigger.now",
            "trading.validity.day"
        ),
        (
            .dummy(
                execution: .limit(230),
                trigger: .priceAtOrBelow(220),
                validity: .goodTillCancelled
            ),
            "trading.review.execution.limit %@",
            "trading.review.trigger.price %@",
            "trading.validity.gtc"
        ),
        (
            .dummy(trigger: .at(Date.dummyNow)),
            "trading.review.execution.market",
            "trading.review.trigger.time %@",
            "trading.validity.day"
        ),
    ])
    func termRowsThenDescribeTypeTriggerAndValidity(
        draft: OrderDraft,
        type: String,
        trigger: String,
        validity: String
    ) {
        // Given / When
        let rows = draft.termRows(currency: .usd)

        // Then
        #expect(rows.map(\.id) == ["type", "trigger", "validity"])
        #expect(rows.map(\.value.resourceKey) == [type, trigger, validity])
    }
}
