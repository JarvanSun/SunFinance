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
        (OrderDraft.make(execution: .limit(90)), Decimal(90)),
        (.make(execution: .limit(90), trigger: .priceAtOrAbove(95)), 90),
        (.make(trigger: .priceAtOrAbove(110)), 110),
        (.make(trigger: .priceAtOrBelow(80)), 80),
        (.make(), 100),
        (.make(trigger: .at(Date(timeIntervalSince1970: 0))), 100),
    ])
    func estimatedPriceThenPrefersLimitThenStopThenMarket(draft: OrderDraft, expected: Decimal) {
        // Then
        #expect(draft.estimatedPrice(marketPrice: 100) == expected)
    }

    @Test(arguments: [
        (OrderAmount.shares(3), Decimal(3)),
        (.euros(1_001), 10),
        (.euros(1_000), Decimal(string: "9.99")!),
        (.euros(1), 0),
    ])
    func quantityThenTurnsEurosIntoWholeStepsAfterTheFee(amount: OrderAmount, expected: Decimal) {
        // When
        let quantity = OrderDraft.make(.buy, amount).quantity(at: 100, fee: 1, scale: 2)

        // Then
        #expect(quantity == expected)
    }

    @Test func quantityWhenPriceIsZeroThenIsZero() {
        // Then
        #expect(OrderDraft.make(.buy, .euros(100)).quantity(at: 0, fee: 1, scale: 4) == 0)
    }

    @Test(arguments: [
        (OrderDraft.make(.buy, .shares(0)), OrderRejection?.some(.invalidAmount)),
        (.make(.buy, .euros(-5)), .invalidAmount),
        (.make(execution: .limit(0)), .invalidPrice),
        (.make(trigger: .priceAtOrAbove(0)), .invalidPrice),
        (.make(trigger: .priceAtOrBelow(-1)), .invalidPrice),
        (.make(trigger: .at(Date(timeIntervalSince1970: 1_000))), .invalidSchedule),
        (.make(trigger: .at(Date(timeIntervalSince1970: 1_000_000))), .invalidSchedule),
        (.make(trigger: .at(Date(timeIntervalSince1970: 5_000))), nil),
        (.make(), nil),
    ])
    func validationIssueThenNamesTheFirstInvalidChoice(
        draft: OrderDraft,
        expected: OrderRejection?
    ) {
        // When
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
        // When
        let isTriggered = OrderDraft.make(trigger: trigger).isTriggered(
            at: Date(timeIntervalSince1970: seconds),
            price: price
        )

        // Then
        #expect(isTriggered == expected)
    }
}
