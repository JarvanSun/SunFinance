//
//  OrderDraftRulesTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct OrderDraftRulesTests {
    @Test(arguments: [
        (OrderDraft.dummy(execution: .limit(90)), Decimal(90)),
        (.dummy(execution: .limit(90), trigger: .priceAtOrAbove(95)), 90),
        (.dummy(trigger: .priceAtOrAbove(110)), 110),
        (.dummy(trigger: .priceAtOrBelow(80)), 80),
        (.dummy(), 100),
        (.dummy(trigger: .at(Date(timeIntervalSince1970: 0))), 100),
    ])
    func estimatedPriceThenPrefersLimitThenStopThenMarket(draft: OrderDraft, expected: Decimal) {
        #expect(draft.estimatedPrice(marketPrice: 100) == expected)
    }

    @Test(arguments: [
        (OrderAmount.shares(3), Decimal(3)),
        (.euros(1_001), 10),
        (.euros(1_000), Decimal(string: "9.99")!),
        (.euros(1), 0),
    ])
    func quantityThenTurnsEurosIntoWholeStepsAfterTheFee(amount: OrderAmount, expected: Decimal) {
        // Given / When
        let quantity = OrderDraft.dummy(.buy, amount).quantity(at: 100, fee: 1, scale: 2)

        // Then
        #expect(quantity == expected)
    }

    @Test func quantityWhenPriceIsZeroThenIsZero() {
        #expect(OrderDraft.dummy(.buy, .euros(100)).quantity(at: 0, fee: 1, scale: 4) == 0)
    }

    @Test(arguments: [
        (OrderDraft.dummy(.buy, .shares(0)), OrderRejection?.some(.invalidAmount)),
        (.dummy(.buy, .euros(-5)), .invalidAmount),
        (.dummy(execution: .limit(0)), .invalidPrice),
        (.dummy(trigger: .priceAtOrAbove(0)), .invalidPrice),
        (.dummy(trigger: .priceAtOrBelow(-1)), .invalidPrice),
        (.dummy(trigger: .at(Date(timeIntervalSince1970: 1_000))), .invalidSchedule),
        (.dummy(trigger: .at(Date(timeIntervalSince1970: 1_000_000))), .invalidSchedule),
        (.dummy(trigger: .at(Date(timeIntervalSince1970: 5_000))), nil),
        (.dummy(), nil),
    ])
    func validationIssueThenNamesTheFirstInvalidChoice(
        draft: OrderDraft,
        expected: OrderRejection?
    ) {
        // Given / When
        let issue = draft.validationIssue(
            at: Date(timeIntervalSince1970: 1_000),
            longestValidity: 86_400
        )

        // Then
        #expect(issue == expected)
    }

    @Test(arguments: [
        (OrderTrigger.immediately, Decimal(100), 0.0, true),
        (.priceAtOrAbove(100), 100, 0, true),
        (.priceAtOrAbove(100), 99, 0, false),
        (.priceAtOrBelow(100), 99, 0, true),
        (.priceAtOrBelow(100), 101, 0, false),
        (.at(Date(timeIntervalSince1970: 60)), 100, 60, true),
        (.at(Date(timeIntervalSince1970: 60)), 100, 59, false),
    ])
    func isTriggeredThenFollowsTheTrigger(
        trigger: OrderTrigger,
        price: Decimal,
        seconds: Double,
        expected: Bool
    ) {
        // Given / When
        let isTriggered = OrderDraft.dummy(trigger: trigger).isTriggered(
            at: Date(timeIntervalSince1970: seconds),
            price: price
        )

        // Then
        #expect(isTriggered == expected)
    }
}
