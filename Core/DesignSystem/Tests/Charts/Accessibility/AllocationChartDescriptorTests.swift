//
//  AllocationChartDescriptorTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Accessibility
import Foundation
import Testing

@testable import DesignSystem

struct AllocationChartDescriptorTests {
    @Test func makeChartDescriptorThenNamesEverySliceWithItsShare() {
        // Given
        let descriptor = AllocationChartDescriptor(
            slices: [
                AllocationSlice(id: "SAP", label: "SAP", value: 300),
                AllocationSlice(id: "cash", label: "Cash", value: 100, tone: .neutral),
            ],
            accessibility: AllocationChartAccessibility(title: "Allocation", summary: "Mostly SAP")
        )

        // When
        let chart = descriptor.makeChartDescriptor()

        // Then
        #expect(chart.title == "Allocation")
        #expect(chart.summary == "Mostly SAP")
        #expect(chart.series.first?.dataPoints.count == 2)
        #expect(descriptor.shares == [0.75, 0.25])
    }

    @Test func sharesWhenTheWholeIsEmptyThenAreZero() {
        // Given
        let descriptor = AllocationChartDescriptor(
            slices: [AllocationSlice(id: "SAP", label: "SAP", value: 0)],
            accessibility: nil
        )

        // When
        let shares = descriptor.shares

        // Then
        #expect(shares == [0])
    }
}
