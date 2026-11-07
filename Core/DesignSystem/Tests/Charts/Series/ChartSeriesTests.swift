//
//  ChartSeriesTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import DesignSystem

struct ChartSeriesTests {
    @Test func initWhenShortThenKeepsEveryPoint() {
        // When
        let series = ChartSeries(makePoints(count: 10), maximumCount: 100)

        // Then
        #expect(series.points.count == 10)
    }

    @Test func initWhenLongThenKeepsEndsAndExtremesInOrderWithinLimit() {
        // Given
        var points = makePoints(count: 2_000)
        points[777] = ChartPoint(date: points[777].date, value: 9_999)
        points[1_234] = ChartPoint(date: points[1_234].date, value: -9_999)

        // When
        let series = ChartSeries(points, maximumCount: 200)

        // Then
        #expect(series.points.count <= 200)
        #expect(series.first == points.first)
        #expect(series.last == points.last)
        #expect(series.points.contains(points[777]))
        #expect(series.points.contains(points[1_234]))
        #expect(zip(series.points, series.points.dropFirst()).allSatisfy { $0.date < $1.date })
    }

    @Test func initResamplingThenAlwaysGivesTheSameCountWithEndsKept() {
        // Given
        let points = (0..<7).map {
            ChartPoint(date: Date(timeIntervalSince1970: Double($0) * 60), value: Double($0 * 10))
        }

        // When
        let series = ChartSeries(resampling: points, count: 13)

        // Then
        #expect(series.points.count == 13)
        #expect(series.points.first == points.first)
        #expect(series.points.last == points.last)
        #expect(abs(series.points[1].value - 5) < 0.0001)
        #expect(series.points[1].date == Date(timeIntervalSince1970: 30))
    }

    @Test func initResamplingWhenTooShortThenKeepsThePoints() {
        // Given
        let point = ChartPoint(date: .now, value: 1)

        // When
        let series = ChartSeries(resampling: [point], count: 10)

        // Then
        #expect(series.points == [point])
    }

    @Test func initResamplingThenNeverOvershootsAPeak() {
        // Given
        let values: [Double] = [1, 5, 5.2, 2, 2, 8]
        let points = values.enumerated().map {
            ChartPoint(date: Date(timeIntervalSince1970: Double($0.offset)), value: $0.element)
        }

        // When
        let series = ChartSeries(resampling: points, count: 101)

        // Then
        #expect(series.points.map(\.value).max() == 8)
        #expect(series.points.map(\.value).min() == 1)
        #expect(series.points.allSatisfy { $0.value >= 1 && $0.value <= 8 })
    }

    @Test func initDrawingWhenLongThenKeepsASpikeThatResamplingAloneWouldMiss() {
        // Given
        var points = (0..<2_000).map {
            ChartPoint(date: Date(timeIntervalSince1970: Double($0) * 60), value: 0)
        }
        points[777] = ChartPoint(date: points[777].date, value: 100)

        // When
        let drawn = ChartSeries(drawing: points, count: 160)
        let resampledOnly = ChartSeries(resampling: points, count: 160)

        // Then
        #expect(drawn.points.count == 160)
        #expect(drawn.points.map(\.value).max() ?? 0 >= 50)
        #expect(resampledOnly.points.map(\.value).max() ?? 0 < 50)
    }

    @Test(arguments: [(0, 0), (5, 5), (99, nil)] as [(Int, Int?)])
    func pointAtIndexThenOnlyInsideTheSeries(index: Int, expected: Int?) {
        // Given
        let series = ChartSeries(makePoints(count: 10), maximumCount: 100)

        // When
        let point = series.point(at: index)

        // Then
        #expect(point?.value == expected.map(Double.init))
    }

    @Test func indexOfDateThenFindsFirstPointAtOrAfterIt() {
        // Given
        let points = makePoints(count: 10)
        let series = ChartSeries(points, maximumCount: 100)

        // Then
        #expect(series.index(of: points[3].date.addingTimeInterval(1)) == 4)
        #expect(series.index(of: .distantFuture) == 9)
    }

    @Test(arguments: [(160, 3, [0, 53, 106]), (1, 3, []), (10, 0, [])] as [(Int, Int, [Int])])
    func tickIndicesThenSpreadFromTheFirstPoint(pointCount: Int, count: Int, expected: [Int]) {
        // Given
        let series = ChartSeries(makePoints(count: pointCount), maximumCount: 1_000)

        // When
        let ticks = series.tickIndices(count: count)

        // Then
        #expect(ticks == expected)
    }
}

private extension ChartSeriesTests {
    func makePoints(count: Int) -> [ChartPoint] {
        (0..<count).map {
            ChartPoint(date: Date(timeIntervalSince1970: Double($0) * 60), value: Double($0))
        }
    }
}
