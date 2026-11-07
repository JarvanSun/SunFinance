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
        let first = keys.key(for: .dummy())
        let second = keys.key(for: .dummy())

        // Then
        #expect(first == second)
    }

    @Test func keyWhenTheDraftChangedThenIsNew() {
        // Given
        let keys = PlacementKeys()

        // When
        let first = keys.key(for: .dummy())
        let edited = keys.key(for: .dummy(amount: .shares(3)))
        let back = keys.key(for: .dummy())

        // Then
        #expect(first != edited)
        #expect(back != first)
    }

    @Test func spendThenTheNextReviewOfTheSameDraftGetsANewKey() {
        // Given
        let keys = PlacementKeys()
        let first = keys.key(for: .dummy())

        // When
        keys.spend(first)
        let next = keys.key(for: .dummy())

        // Then
        #expect(next != first)
    }

    @Test func spendWhenTheKeyIsNoLongerCurrentThenKeepsTheCurrentOne() {
        // Given
        let keys = PlacementKeys()
        let old = keys.key(for: .dummy())
        let current = keys.key(for: .dummy(amount: .shares(3)))

        // When
        keys.spend(old)

        // Then
        #expect(keys.key(for: .dummy(amount: .shares(3))) == current)
    }
}
