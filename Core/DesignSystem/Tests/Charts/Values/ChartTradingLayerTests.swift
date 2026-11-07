//
//  ChartTradingLayerTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import DesignSystem

struct ChartTradingLayerTests {
    @Test func valuesThenHoldEveryMarkerAndLevelPrice() {
        // Given
        let layer = ChartTradingLayer(
            markers: [ChartMarker(date: .now, value: 10, kind: .buy)],
            levels: [ChartLevel(id: "limit", value: 12, label: "Limit")]
        )

        // When
        let values = layer.values

        // Then
        #expect(values == [10, 12])
    }

    @Test func initThenDrawsNothing() {
        // When
        let layer = ChartTradingLayer()

        // Then
        #expect(layer.markers.isEmpty)
        #expect(layer.levels.isEmpty)
    }
}
