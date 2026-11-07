//
//  TradingSnapshotChartingTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct TradingSnapshotChartingTests {
    @Test func chartLayerThenMarksFillsInsideTheRangeOnly() {
        // Given
        let history = appleDayHistory
        let start = history.candles[0].start
        let before = start.addingTimeInterval(-60)
        let trading = TradingSnapshot(
            position: nil,
            orders: [
                .init("AAPL", side: .buy, status: .filled, fillDate: start.addingTimeInterval(60)),
                .init("AAPL", side: .sell, status: .filled, fillDate: before),
                .init("AAPL", status: .waitingForPrice),
            ]
        )

        // When
        let layer = trading.chartLayer(for: history)

        // Then
        #expect(layer.markers.map(\.kind) == [.buy])
        #expect(layer.markers.map(\.value) == [105])
    }

    @Test func chartLayerThenDrawsLimitAndTriggerOfOpenOrders() {
        // Given
        let trading = TradingSnapshot(
            position: nil,
            orders: [
                .init(
                    "AAPL",
                    execution: .limit(100),
                    trigger: .priceAtOrBelow(98),
                    status: .waitingForTrigger
                ),
                .init("AAPL", execution: .limit(90), status: .cancelled),
            ]
        )

        // When
        let layer = trading.chartLayer(for: appleDayHistory)

        // Then
        #expect(layer.levels.map(\.value) == [100, 98])
        #expect(Set(layer.levels.map(\.id)).count == 2)
    }
}
