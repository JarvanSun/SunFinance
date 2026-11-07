//
//  SetExtensionsTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import Watchlist

struct SetExtensionsTests {
    @Test func toggleWhenMemberIsMissingThenInsertsAndReturnsTrue() {
        // Given
        var numbers: Set = [1]

        // When
        let isMember = numbers.toggle(2)

        // Then
        #expect(isMember)
        #expect(numbers == [1, 2])
    }

    @Test func toggleWhenMemberExistsThenRemovesAndReturnsFalse() {
        // Given
        var numbers: Set = [1, 2]

        // When
        let isMember = numbers.toggle(2)

        // Then
        #expect(!isMember)
        #expect(numbers == [1])
    }
}
