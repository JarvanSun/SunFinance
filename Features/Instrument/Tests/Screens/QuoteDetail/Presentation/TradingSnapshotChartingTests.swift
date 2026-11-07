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
        let history = PriceHistory.dummyAppleDay
        let start = history.candles[0].start
        let before = start.addingTimeInterval(-60)
        let trading = TradingSnapshot(
            position: nil,
            orders: [
                .dummy("AAPL", side: .buy, status: .filled, fillDate: start.addingTimeInterval(60)),
                .dummy("AAPL", side: .sell, status: .filled, fillDate: before),
                .dummy("AAPL", status: .waitingForPrice),
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
                .dummy(
                    "AAPL",
                    execution: .limit(100),
                    trigger: .priceAtOrBelow(98),
                    status: .waitingForTrigger
                ),
                .dummy("AAPL", execution: .limit(90), status: .cancelled),
            ]
        )

        // When
        let layer = trading.chartLayer(for: PriceHistory.dummyAppleDay)

        // Then
        #expect(layer.levels.map(\.value) == [100, 98])
        #expect(Set(layer.levels.map(\.id)).count == 2)
    }
}
