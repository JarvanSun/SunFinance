//
//  OrderTriggerScheduleTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct OrderTriggerScheduleTests {
    @Test(arguments: [
        (OrderTrigger.at(.distantFuture), Date?.some(.distantFuture)),
        (.immediately, nil),
        (.priceAtOrAbove(10), nil),
        (.priceAtOrBelow(10), nil),
    ])
    func scheduledTimeThenIsSetOnlyForATimeTrigger(trigger: OrderTrigger, expected: Date?) {
        // Then
        #expect(trigger.scheduledTime == expected)
    }
}
