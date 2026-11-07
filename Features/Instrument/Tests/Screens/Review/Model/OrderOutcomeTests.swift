//
//  OrderOutcomeTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct OrderOutcomeTests {
    @Test(arguments: [
        (OrderStatus.waitingForPrice, OrderTrigger.immediately, OrderOutcome.waitingForPrice),
        (.waitingForTrigger, .priceAtOrAbove(250), .waitingForTrigger),
        (.scheduled, .at(Date.dummyNow), .scheduled(Date.dummyNow)),
        (.scheduled, .immediately, .waitingForOpen),
        (.waitingForOpen, .immediately, .waitingForOpen),
        (.cancelled, .immediately, .cancelled),
        (.expired, .priceAtOrBelow(1), .expired),
        (.rejected(.insufficientCash), .immediately, .rejected(.insufficientCash)),
    ])
    func initThenFollowsTheStatus(status: OrderStatus, trigger: OrderTrigger, outcome: OrderOutcome)
    {
        // Given / When
        let result = OrderOutcome(.dummy(.dummy(trigger: trigger), status: status))

        // Then
        #expect(result == outcome)
    }

    @Test func initWhenFilledThenCarriesTheFill() {
        // Given
        let order = Order.dummy(status: .filled)

        // When
        let outcome = OrderOutcome(order)

        // Then
        #expect(outcome == .filled(order.fill!))
    }

    @Test func initWhenFilledWithoutAFillThenSaysSoWithoutFigures() {
        // Given
        let order = Order.dummy(status: .filled).withoutFill

        // When
        let outcome = OrderOutcome(order)

        // Then
        #expect(outcome == .filledWithoutDetails)
    }

    @Test(arguments: [
        (OrderOutcome.rejected(.invalidPrice), true),
        (.cancelled, true),
        (.expired, true),
        (.filledWithoutDetails, false),
        (.waitingForPrice, false),
        (.waitingForTrigger, false),
        (.scheduled(Date.dummyNow), false),
        (.waitingForOpen, false),
    ])
    func allowsEditingThenOnlyWhenNothingTraded(outcome: OrderOutcome, allowsEditing: Bool) {
        #expect(outcome.allowsEditing == allowsEditing)
    }
}
