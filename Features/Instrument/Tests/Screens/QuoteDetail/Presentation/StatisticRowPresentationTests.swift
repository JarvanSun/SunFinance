//
//  StatisticRowPresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

@testable import Instrument

struct StatisticRowPresentationTests {
    @Test func metricThenShowsTheValueOverTheTitle() {
        // Given
        let row = StatisticRow(title: "Open", value: "$100.00")

        // When
        let metric = row.metric

        // Then
        #expect(metric.id == row.id)
        #expect(metric.value == "$100.00")
        #expect(metric.trend == nil)
    }
}
