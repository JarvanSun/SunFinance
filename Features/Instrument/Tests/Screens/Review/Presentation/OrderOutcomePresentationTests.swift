//
//  OrderOutcomePresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import SwiftUI
import Testing

@testable import Instrument

struct OrderOutcomePresentationTests {
    @Test(arguments: [
        (OrderOutcome.filled(.filledSample), FinanceImage.success, FinanceColor.gain),
        (.filledWithoutDetails, .success, .gain),
        (.waitingForPrice, .scheduled, .accent),
        (.scheduled(.testNow), .scheduled, .accent),
        (.cancelled, .rejected, .textSecondary),
        (.expired, .rejected, .textSecondary),
        (.rejected(.insufficientCash), .rejected, .critical),
    ])
    func badgeThenFollowsTheOutcome(outcome: OrderOutcome, image: FinanceImage, color: FinanceColor)
    {
        // Then
        #expect(outcome.image == image)
        #expect(outcome.color == color)
    }

    @Test(arguments: [
        (OrderOutcome.filledWithoutDetails, true),
        (.waitingForOpen, false),
        (.rejected(.invalidAmount), false),
    ])
    func feedbackThenCelebratesOnlyAFill(outcome: OrderOutcome, celebrates: Bool) {
        // Then
        #expect((outcome.feedback == .success) == celebrates)
    }

    @Test(arguments: [
        (OrderOutcome.rejected(.invalidAmount), FinanceButtonKind.secondary),
        (.waitingForOpen, .primary),
    ])
    func doneButtonKindThenStepsBackWhenEditingIsOffered(
        outcome: OrderOutcome,
        kind: FinanceButtonKind
    ) {
        // Then
        #expect(outcome.doneButtonKind == kind)
    }

    @Test(arguments: [
        (OrderOutcome.filled(.filledSample), "trading.result.filled.buy %@ %@"),
        (.filledWithoutDetails, "trading.result.filledWithoutDetails"),
        (.waitingForTrigger, "trading.result.placed"),
        (.cancelled, "trading.result.cancelled"),
        (.expired, "trading.result.expired"),
        (.rejected(.insufficientCash), "trading.result.rejected"),
    ])
    func titleThenSaysWhatHappened(outcome: OrderOutcome, key: String) {
        // Then
        #expect(outcome.title(for: .make()).key == key)
    }

    @Test func titleWhenASellFilledThenSaysSold() {
        // When
        let title = OrderOutcome.filled(.filledSample).title(for: .make(.sell))

        // Then
        #expect(title.key == "trading.result.filled.sell %@ %@")
    }

    @Test(arguments: [
        (
            OrderOutcome.filled(.filledSample),
            OrderTrigger.immediately,
            "trading.result.filled.detail %@ %@"
        ),
        (.filledWithoutDetails, .immediately, "trading.result.filledWithoutDetails.detail"),
        (.waitingForPrice, .immediately, "trading.result.waitingForPrice"),
        (.waitingForTrigger, .priceAtOrAbove(250), "trading.result.waitingForTrigger %@"),
        (.waitingForTrigger, .immediately, "trading.result.waitingForOpen"),
        (.scheduled(.testNow), .at(.testNow), "trading.result.scheduled %@"),
        (.waitingForOpen, .immediately, "trading.result.waitingForOpen"),
        (.cancelled, .immediately, "trading.result.cancelled.detail"),
        (.expired, .immediately, "trading.result.expired.detail"),
        (.rejected(.insufficientShares), .immediately, "trading.rejection.insufficientShares"),
    ])
    func detailThenExplainsWhatComesNext(
        outcome: OrderOutcome,
        trigger: OrderTrigger,
        key: String
    ) {
        // Then
        #expect(outcome.detail(for: .make(trigger: trigger), currency: .usd).key == key)
    }
}
