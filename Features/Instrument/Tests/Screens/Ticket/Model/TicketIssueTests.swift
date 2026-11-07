//
//  TicketIssueTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Instrument

struct TicketIssueTests {
    @Test(arguments: [
        (OrderRejection.insufficientCash, TicketIssue.insufficientCash),
        (.insufficientShares, .insufficientShares),
        (.invalidAmount, .belowShareStep),
        (.invalidPrice, .notPositive),
        (.invalidSchedule, .outsideSchedule),
        (.unknownSymbol, .notTradable),
    ])
    func initThenNamesWhatTheServerPredicts(rejection: OrderRejection, expected: TicketIssue) {
        // Then
        #expect(TicketIssue(rejection) == expected)
    }

    @Test(arguments: [
        (TicketIssue.missing, true),
        (.notANumber, false),
        (.insufficientCash, false),
    ])
    func waitsForReviewAttemptThenOnlyForAnEmptyField(issue: TicketIssue, waits: Bool) {
        // Then
        #expect(issue.waitsForReviewAttempt == waits)
    }
}
