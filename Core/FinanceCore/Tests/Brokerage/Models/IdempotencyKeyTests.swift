//
//  IdempotencyKeyTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct IdempotencyKeyTests {
    @Test func initThenCreatesADifferentKeyEachTime() {
        // When
        let first = IdempotencyKey()
        let second = IdempotencyKey()

        // Then
        #expect(first != second)
        #expect(!first.rawValue.isEmpty)
    }
}
