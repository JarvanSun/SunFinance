//
//  PositionPresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct PositionPresentationTests {
    @Test func metricsWhenForeignThenAddTheCurrencyEffect() {
        // Given
        let position = Position.dummy(holding: "AAPL", quantity: 3)

        // When
        let ids = position.metrics.map(\.id)

        // Then
        #expect(
            ids == [
                "value", "gain", "price", "gainPercent", "shares", "today", "realized",
                "currencyEffect", "totalReturn",
            ]
        )
    }

    @Test func metricsWhenInEurosThenLeaveOutTheCurrencyEffect() {
        // Given
        let position = Position.dummyEuroHolding

        // When
        let ids = position.metrics.map(\.id)

        // Then
        #expect(!ids.contains("currencyEffect"))
        #expect(ids.count == 8)
    }

    @Test func metricsThenColorOnlyGainsAndLosses() {
        // Given / When
        let trends = Position.dummyEuroHolding.metrics.map(\.trend)

        // Then
        #expect(trends[0] == nil)
        #expect(trends[1] == .loss)
    }
}
