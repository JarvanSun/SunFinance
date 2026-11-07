//
//  ValueScale.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct ValueScale: Equatable, Sendable {
    let low: Double?
    let high: Double?

    var guideValues: [Double] {
        guard let low, let high, high > low else { return [] }

        let step = roundStep(for: high - low)
        return [(low / step).rounded(.down) * step, (high / step).rounded(.up) * step]
    }

    init(values: [Double]) {
        low = values.min()
        high = values.max()
    }

    func domain(including extraValues: [Double]) -> ClosedRange<Double> {
        let values = [low, high].compactMap { $0 } + extraValues
        let lower = values.min() ?? emptyDomain.lowerBound
        let upper = values.max() ?? emptyDomain.upperBound
        let padding = max((upper - lower) * paddingRatio, minimumPadding)
        return (lower - padding)...(upper + padding)
    }

    func roundStep(for span: Double) -> Double {
        pow(10, log10(span / 2).rounded(.down))
    }
}

private extension ValueScale {
    var emptyDomain: ClosedRange<Double> { 0...1 }

    var paddingRatio: Double { 0.08 }

    var minimumPadding: Double { 0.01 }
}
