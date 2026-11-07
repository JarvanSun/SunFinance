//
//  TicketChoicePresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import Instrument

struct TicketChoicePresentationTests {
    @Test(arguments: [
        (AmountMode.shares, "trading.amount.mode.shares", "trading.amount.field.shares"),
        (.euros, "trading.amount.mode.euros", "trading.amount.field.euros"),
    ])
    func amountModeThenTitlesSegmentAndField(mode: AmountMode, segment: String, field: String) {
        // Then
        #expect(mode.segmentTitle.key == segment)
        #expect(mode.fieldTitle.key == field)
    }

    @Test(arguments: [
        (ExecutionKind.market, "trading.execution.market"),
        (.limit, "trading.execution.limit"),
    ])
    func executionKindThenTitlesTheSegment(kind: ExecutionKind, key: String) {
        // Then
        #expect(kind.segmentTitle.key == key)
    }

    @Test(arguments: [
        (TriggerKind.now, "trading.trigger.now"),
        (.price, "trading.trigger.price"),
        (.time, "trading.trigger.time"),
    ])
    func triggerKindThenTitlesTheSegment(kind: TriggerKind, key: String) {
        // Then
        #expect(kind.segmentTitle.key == key)
    }
}
