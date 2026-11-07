//
//  TicketFormTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct TicketFormTests {
    let input = DecimalInput(locale: Locale(identifier: "en_US"))

    @Test(arguments: [
        ("", TicketIssue.missing),
        ("abc", TicketIssue.notANumber),
        ("0", TicketIssue.notPositive),
        ("1.00001", TicketIssue.tooPrecise),
    ])
    func issuesWhenAmountIsInvalidThenNamesTheProblem(text: String, issue: TicketIssue) {
        // Given
        var form = TicketForm(side: .buy, triggerDate: Date.dummyNow)
        form.amountText = text

        // When / Then
        #expect(form.issues(input: input, now: Date.dummyNow) == [.amount: issue])
    }

    @Test func issuesWhenEurosHaveCentsThenAllowsThem() {
        // Given
        var form = TicketForm(side: .buy, triggerDate: Date.dummyNow)
        form.amountMode = .euros
        form.amountText = "500.55"

        // When / Then
        #expect(form.issues(input: input, now: Date.dummyNow).isEmpty)
    }

    @Test(arguments: [(-60.0, TicketIssue.notInFuture), (91 * 86_400.0, TicketIssue.tooFar)])
    func issuesWhenScheduleIsOutOfRangeThenFlagsTheTime(offset: TimeInterval, issue: TicketIssue) {
        // Given
        var form = TicketForm(side: .buy, triggerDate: Date.dummyNow.addingTimeInterval(offset))
        form.amountText = "1"
        form.trigger = .time

        // When / Then
        #expect(form.issues(input: input, now: Date.dummyNow) == [.triggerTime: issue])
    }

    @Test func draftWhenStopLimitSellThenFallsToTheTriggerWithTheChosenValidity() {
        // Given
        var form = TicketForm(side: .sell, triggerDate: Date.dummyNow)
        form.amountText = "5"
        form.execution = .limit
        form.limitText = "190"
        form.trigger = .price
        form.triggerPriceText = "195"
        form.validity = .goodTillCancelled

        // When
        let draft = form.draft(symbol: "AAPL", input: input, now: Date.dummyNow)

        // Then
        #expect(
            draft
                == .dummy(
                    .sell,
                    amount: .shares(5),
                    execution: .limit(190),
                    trigger: .priceAtOrBelow(195),
                    validity: .goodTillCancelled
                )
        )
    }

    @Test func draftWhenMarketNowThenAlwaysForTheDay() {
        // Given
        var form = TicketForm(side: .buy, triggerDate: Date.dummyNow)
        form.amountText = "2"
        form.validity = .goodTillCancelled

        // When
        let draft = form.draft(symbol: "AAPL", input: input, now: Date.dummyNow)

        // Then
        #expect(draft == .dummy())
    }

    @Test func draftWhenALimitIsMissingThenIsNil() {
        // Given
        var form = TicketForm(side: .buy, triggerDate: Date.dummyNow)
        form.amountText = "2"
        form.execution = .limit

        // When / Then
        #expect(form.draft(symbol: "AAPL", input: input, now: Date.dummyNow) == nil)
        #expect(form.issues(input: input, now: Date.dummyNow) == [.limitPrice: .missing])
    }

    @Test func scheduleRangeThenRunsNinetyDaysFromNow() {
        // Given
        let form = TicketForm(side: .buy, triggerDate: Date.dummyNow)

        // When
        let range = form.scheduleRange(from: Date.dummyNow)

        // Then
        #expect(range == Date.dummyNow...Date.dummyNow.addingTimeInterval(90 * 86_400))
    }

    @Test func revealsWhenChoicesChangeThenFollowExecutionAndTrigger() {
        // Given
        var form = TicketForm(side: .buy, triggerDate: Date.dummyNow)

        // When
        form.execution = .limit
        form.trigger = .time

        // Then
        #expect(form.hasLimit)
        #expect(!form.hasTriggerPrice)
        #expect(form.hasTriggerTime)
        #expect(form.offersValidity)
    }
}
