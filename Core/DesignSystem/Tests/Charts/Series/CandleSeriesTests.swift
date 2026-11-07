//
//  CandleSeriesTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import DesignSystem

struct CandleSeriesTests {
    @Test func initWhenShortThenKeepsEveryCandle() {
        // Given
        let candles = ChartCandle.dummySeries(count: 10)

        // When
        let series = CandleSeries(candles, maximumCount: 90)

        // Then
        #expect(series.candles == candles)
    }

    @Test func initWhenLongThenMergesNeighboursIntoWiderCandles() throws {
        // Given
        let candles = ChartCandle.dummySeries(count: 10)

        // When
        let series = CandleSeries(candles, maximumCount: 4)

        // Then
        let first = try #require(series.candles.first)
        #expect(series.candles.count == 4)
        #expect(first.date == candles[0].date)
        #expect(first.open == candles[0].open)
        #expect(first.close == candles[2].close)
        #expect(first.high == candles[0...2].map(\.high).max())
        #expect(first.low == candles[0...2].map(\.low).min())
        #expect(first.volume == candles[0...2].reduce(0) { $0 + $1.volume })
        #expect(series.candles.last?.close == candles[9].close)
    }

    @Test func scaleThenSpansEveryLowAndHigh() {
        // Given
        let series = CandleSeries(ChartCandle.dummySeries(count: 5), maximumCount: 90)

        // When
        let scale = series.scale

        // Then
        #expect(scale.low == 9)
        #expect(scale.high == 16)
    }

    @Test func slotOfDateThenFindsTheCandleTheMomentFallsIn() {
        // Given
        let candles = ChartCandle.dummySeries(count: 5)
        let series = CandleSeries(candles, maximumCount: 90)

        // Then
        #expect(series.slot(of: candles[2].date.addingTimeInterval(60)) == "2")
        #expect(series.slot(of: .distantPast) == "0")
        #expect(series.slot(of: .distantFuture) == "4")
    }

    @Test(arguments: [("1", 1), ("7", nil), (nil, nil)] as [(String?, Int?)])
    func candleAtSlotThenOnlyInsideTheSeries(slot: String?, index: Int?) {
        // Given
        let candles = ChartCandle.dummySeries(count: 5)
        let series = CandleSeries(candles, maximumCount: 90)

        // When
        let candle = series.candle(atSlot: slot)

        // Then
        #expect(candle == index.map { candles[$0] })
    }

    @Test func closePointsThenFollowTheCloses() {
        // Given
        let candles = ChartCandle.dummySeries(count: 3)

        // When
        let points = CandleSeries(candles, maximumCount: 90).closePoints

        // Then
        #expect(points.map(\.value) == candles.map(\.close))
        #expect(points.map(\.date) == candles.map(\.date))
    }
}
