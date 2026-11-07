//
//  ChartSeries.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct ChartSeries: Equatable, Sendable {
    let points: [ChartPoint]

    var indices: Range<Int> {
        points.indices
    }

    var first: ChartPoint? {
        points.first
    }

    var last: ChartPoint? {
        points.last
    }

    init(_ points: [ChartPoint], maximumCount: Int) {
        self.points = downsampled(points, to: maximumCount)
    }

    init(resampling points: [ChartPoint], count: Int) {
        self.points = resampled(points, to: count)
    }

    init(drawing points: [ChartPoint], count: Int) {
        self.points = resampled(downsampled(points, to: count), to: count)
    }

    func point(at index: Int?) -> ChartPoint? {
        index.flatMap { points.indices.contains($0) ? points[$0] : nil }
    }

    func index(of date: Date) -> Int? {
        points.firstIndex { $0.date >= date } ?? points.indices.last
    }

    func tickIndices(count: Int) -> [Int] {
        guard points.count > 1, count > 0 else { return [] }

        let last = points.count - 1
        return (0..<count).map { last * $0 / count }
    }
}

private func downsampled(_ points: [ChartPoint], to maximumCount: Int) -> [ChartPoint] {
    guard points.count > maximumCount, maximumCount >= 4 else { return points }

    let interior = points.dropFirst().dropLast()
    let bucketCount = (maximumCount - 2) / 2
    let bucketSize = Int((Double(interior.count) / Double(bucketCount)).rounded(.up))
    let starts = stride(from: interior.startIndex, to: interior.endIndex, by: bucketSize)
    let kept = starts.flatMap { start in
        extremes(of: interior[start..<min(start + bucketSize, interior.endIndex)])
    }
    return [points[0]] + kept + [points[points.count - 1]]
}

private func resampled(_ points: [ChartPoint], to count: Int) -> [ChartPoint] {
    guard points.count >= 2, count >= 2 else { return points }

    let values = points.map(\.value)
    let slopes = monotoneSlopes(of: values)
    let last = Double(points.count - 1)
    return (0..<count).map { step in
        let position = Double(step) / Double(count - 1) * last
        let lower = min(Int(position.rounded(.down)), points.count - 2)
        let share = position - Double(lower)
        let from = points[lower]
        let to = points[lower + 1]
        return ChartPoint(
            date: from.date.addingTimeInterval(to.date.timeIntervalSince(from.date) * share),
            value: hermite(from.value, to.value, slopes[lower], slopes[lower + 1], share)
        )
    }
}

private func monotoneSlopes(of values: [Double]) -> [Double] {
    let secants = zip(values.dropFirst(), values).map { $0 - $1 }
    var slopes =
        [secants[0]]
        + zip(secants, secants.dropFirst()).map { left, right in
            left * right <= 0 ? 0 : (left + right) / 2
        } + [secants[secants.count - 1]]
    for (index, secant) in secants.enumerated() {
        guard secant != 0 else {
            slopes[index] = 0
            slopes[index + 1] = 0
            continue
        }

        let alpha = slopes[index] / secant
        let beta = slopes[index + 1] / secant
        let length = alpha * alpha + beta * beta
        guard length > slopeLimit * slopeLimit else { continue }

        let scale = slopeLimit / length.squareRoot()
        slopes[index] = scale * alpha * secant
        slopes[index + 1] = scale * beta * secant
    }
    return slopes
}

private func hermite(
    _ from: Double,
    _ to: Double,
    _ fromSlope: Double,
    _ toSlope: Double,
    _ share: Double
) -> Double {
    let square = share * share
    let cube = square * share
    return (2 * cube - 3 * square + 1) * from
        + (cube - 2 * square + share) * fromSlope
        + (-2 * cube + 3 * square) * to
        + (cube - square) * toSlope
}

private func extremes(of bucket: ArraySlice<ChartPoint>) -> [ChartPoint] {
    let low = bucket.min { $0.value < $1.value }
    let high = bucket.max { $0.value < $1.value }
    return [low, high]
        .compactMap { $0 }
        .reduce(into: [ChartPoint]()) { kept, point in
            guard !kept.contains(point) else { return }

            kept.append(point)
        }
        .sorted { $0.date < $1.date }
}

private let slopeLimit: Double = 3
