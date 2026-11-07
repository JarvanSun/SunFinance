//
//  TicketIssuePresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import Instrument

struct TicketIssuePresentationTests {
    @Test(arguments: [
        (TicketIssue.missing, TicketField.amount, "trading.issue.amount.missing"),
        (.missing, .limitPrice, "trading.issue.price.missing"),
        (.missing, .triggerPrice, "trading.issue.price.missing"),
        (.notANumber, .amount, "trading.issue.notANumber"),
        (.notPositive, .limitPrice, "trading.issue.notPositive"),
        (.tooPrecise, .amount, "trading.issue.tooPrecise"),
        (.notInFuture, .triggerTime, "trading.issue.notInFuture"),
        (.tooFar, .triggerTime, "trading.issue.tooFar"),
        (.insufficientCash, .amount, "trading.issue.insufficientCash"),
        (.insufficientShares, .amount, "trading.issue.insufficientShares"),
        (.belowShareStep, .amount, "trading.issue.belowShareStep"),
        (.notTradable, .amount, "trading.issue.notTradable"),
        (.outsideSchedule, .triggerTime, "trading.issue.outsideSchedule"),
    ])
    func messageThenExplainsTheIssueForItsField(
        issue: TicketIssue,
        field: TicketField,
        key: String
    ) {
        // Then
        #expect(issue.message(for: field).key == key)
    }
}
