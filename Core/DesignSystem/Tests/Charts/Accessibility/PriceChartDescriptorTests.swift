//
//  PriceChartDescriptorTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Accessibility
import Foundation
import Testing

@testable import DesignSystem

struct PriceChartDescriptorTests {
    @Test func makeChartDescriptorThenDescribesEveryPointWithTheFeaturesWords() {
        // Given
        let points = (0..<5).map {
            ChartPoint(date: Date(timeIntervalSince1970: Double($0)), value: Double($0) + 10)
        }
        let descriptor = PriceChartDescriptor(
            points: points,
            accessibility: ChartAccessibility(
                title: "Apple",
                summary: "Apple, up",
                valueDescription: { "\($0)" },
                dateDescription: { "\($0.timeIntervalSince1970)" }
            )
        )

        // When
        let chart = descriptor.makeChartDescriptor()

        // Then
        #expect(chart.title == "Apple")
        #expect(chart.summary == "Apple, up")
        #expect(chart.series.first?.dataPoints.count == 5)
    }
}
