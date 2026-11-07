//
//  DurationExtensionsTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct DurationExtensionsTests {
    @Test(arguments: [(Duration.seconds(2), 2.0), (.milliseconds(250), 0.25)])
    func timeIntervalThenConvertsToSeconds(duration: Duration, expected: Double) {
        // Given / When
        let timeInterval = duration.timeInterval

        // Then
        #expect(timeInterval == expected)
    }
}
