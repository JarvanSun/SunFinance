//
//  StateActionTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunUserInterface
import Testing

@testable import DesignSystem

struct StateActionTests {
    @Test func initWithoutIdentifierThenHasEmptyIdentifier() {
        // Given / When
        let action = StateAction(title: "Try again", perform: {})

        // Then
        #expect(action.accessibilityIdentifier.isEmpty)
    }

    @Test func initWithIdentifierThenUsesItsRawValue() {
        // Given / When
        let action = StateAction(
            title: "Try again",
            accessibilityIdentifier: Identifier.retry,
            perform: {}
        )

        // Then
        #expect(action.accessibilityIdentifier == "test.retry")
    }
}

private extension StateActionTests {
    enum Identifier: String, AccessibilityIdentifying {
        case retry = "test.retry"
    }
}
