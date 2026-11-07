//
//  PriceHistoryChartingTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct PriceHistoryChartingTests {
    @Test func chartValuesThenFollowCandles() {
        // Given
        let history = PriceHistory.appleDay

        // Then
        #expect(history.chartPoints.map(\.value) == [105, 110])
        #expect(history.chartCandles.map(\.high) == [106, 111])
        #expect(history.chartBaseline == 100)
    }

    @Test func chartAccessibilityThenSummarisesRangeAndChange() {
        // When
        let accessibility = PriceHistory.appleDay.chartAccessibility(companyName: "Apple")

        // Then
        #expect(accessibility.summary.key == "quoteDetail.chart.summary %@ %@ %@ %@ %@")
        #expect(accessibility.title.key == "quoteDetail.chart.title %@")
    }

    @Test func chartAccessibilityWithoutPricesThenSaysSo() {
        // Given
        let history = PriceHistory(
            symbol: "AAPL",
            range: .week,
            currency: .usd,
            baseline: nil,
            candles: []
        )

        // When
        let accessibility = history.chartAccessibility(companyName: "Apple")

        // Then
        #expect(accessibility.summary.key == "quoteDetail.chart.summary.empty %@ %@")
    }

    @Test func candlestickContentThenCarriesTheTradingLayer() {
        // Given
        let fillDate = PriceHistory.appleDay.candles[0].start.addingTimeInterval(60)
        let trading = TradingSnapshot(
            position: nil,
            orders: [.make("AAPL", status: .filled, fillDate: fillDate)]
        )

        // When
        let content = PriceHistory.appleDay.candlestickContent(
            trading: trading,
            companyName: "Apple"
        )

        // Then
        #expect(content.trading.markers.count == 1)
        #expect(content.candles.count == 2)
    }
}
