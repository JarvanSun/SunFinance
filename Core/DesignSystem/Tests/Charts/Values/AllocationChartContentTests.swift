//
//  AllocationChartContentTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import DesignSystem

struct AllocationChartContentTests {
    @Test func initThenLeavesOutEmptySlices() {
        // Given
        let sap = AllocationSlice(id: "SAP", label: "SAP", value: 300)
        let sold = AllocationSlice(id: "NVDA", label: "NVDA", value: 0)

        // When
        let content = AllocationChartContent(slices: [sap, sold])

        // Then
        #expect(content.slices == [sap])
    }
}
