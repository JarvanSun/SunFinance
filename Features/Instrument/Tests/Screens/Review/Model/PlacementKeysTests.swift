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
        let first = keys.key(for: .init())
        let second = keys.key(for: .init())

        // Then
        #expect(first == second)
    }

    @Test func keyWhenTheDraftChangedThenIsNew() {
        // Given
        let keys = PlacementKeys()

        // When
        let first = keys.key(for: .init())
        let edited = keys.key(for: .init(amount: .shares(3)))
        let back = keys.key(for: .init())

        // Then
        #expect(first != edited)
        #expect(back != first)
    }

    @Test func spendThenTheNextReviewOfTheSameDraftGetsANewKey() {
        // Given
        let keys = PlacementKeys()
        let first = keys.key(for: .init())

        // When
        keys.spend(first)
        let next = keys.key(for: .init())

        // Then
        #expect(next != first)
    }

    @Test func spendWhenTheKeyIsNoLongerCurrentThenKeepsTheCurrentOne() {
        // Given
        let keys = PlacementKeys()
        let old = keys.key(for: .init())
        let current = keys.key(for: .init(amount: .shares(3)))

        // When
        keys.spend(old)

        // Then
        #expect(keys.key(for: .init(amount: .shares(3))) == current)
    }
}
