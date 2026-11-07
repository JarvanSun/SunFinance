//
//  PlacementKeysTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct PlacementKeysTests {
    @Test func keyWhenTheSameDraftIsReviewedAgainThenStaysTheSame() {
        // Given
        let keys = PlacementKeys()

        // When
        let first = keys.key(for: .make())
        let second = keys.key(for: .make())

        // Then
        #expect(first == second)
    }

    @Test func keyWhenTheDraftChangedThenIsNew() {
        // Given
        let keys = PlacementKeys()

        // When
        let first = keys.key(for: .make())
        let edited = keys.key(for: .make(amount: .shares(3)))
        let back = keys.key(for: .make())

        // Then
        #expect(first != edited)
        #expect(back != first)
    }

    @Test func spendThenTheNextReviewOfTheSameDraftGetsANewKey() {
        // Given
        let keys = PlacementKeys()
        let first = keys.key(for: .make())

        // When
        keys.spend(first)
        let next = keys.key(for: .make())

        // Then
        #expect(next != first)
    }

    @Test func spendWhenTheKeyIsNoLongerCurrentThenKeepsTheCurrentOne() {
        // Given
        let keys = PlacementKeys()
        let old = keys.key(for: .make())
        let current = keys.key(for: .make(amount: .shares(3)))

        // When
        keys.spend(old)

        // Then
        #expect(keys.key(for: .make(amount: .shares(3))) == current)
    }
}
