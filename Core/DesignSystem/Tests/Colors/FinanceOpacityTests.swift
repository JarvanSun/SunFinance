//
//  FinanceOpacityTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import DesignSystem

struct FinanceOpacityTests {
    @Test func valueWhenDimmedThenStaysReadable() {
        // When
        let value = FinanceOpacity.dimmed.value

        // Then
        #expect(value == 0.4)
    }
}
