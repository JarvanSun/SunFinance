//
//  ChartLevelTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import DesignSystem

struct ChartLevelTests {
    @Test func equalityThenUsesIDAndValue() {
        // Given
        let limit = ChartLevel(id: "order-1-limit", value: 1, label: "Limit")

        // Then
        #expect(limit == ChartLevel(id: "order-1-limit", value: 1, label: "Limit"))
        #expect(limit != ChartLevel(id: "order-2-limit", value: 1, label: "Limit"))
        #expect(limit != ChartLevel(id: "order-1-limit", value: 2, label: "Limit"))
        #expect(Set([limit, ChartLevel(id: "order-1-limit", value: 1, label: "Limit")]).count == 1)
    }
}
