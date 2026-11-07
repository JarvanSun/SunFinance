//
//  MockServerBehaviorTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct MockServerBehaviorTests {
    @Test(arguments: [
        (
            MockServerBehavior.realistic, Duration.milliseconds(250)...(.milliseconds(900)), 0.05,
            0.0
        ),
        (.instant, .zero...(.zero), 0, 0),
        (.failingReads, .zero...(.zero), 1, 0),
        (.alwaysFailing, .zero...(.zero), 1, 1),
    ])
    func behaviorThenHasItsLatencyAndFailureRates(
        behavior: MockServerBehavior,
        latency: ClosedRange<Duration>,
        readFailureRate: Double,
        writeFailureRate: Double
    ) {
        #expect(behavior.latency == latency)
        #expect(behavior.readFailureRate == readFailureRate)
        #expect(behavior.writeFailureRate == writeFailureRate)
    }
}
