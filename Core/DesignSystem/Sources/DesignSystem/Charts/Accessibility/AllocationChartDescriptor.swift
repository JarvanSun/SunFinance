//
//  AllocationChartDescriptor.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Accessibility
import Foundation
import SwiftUI

struct AllocationChartDescriptor: AXChartDescriptorRepresentable {
    let slices: [AllocationSlice]
    let accessibility: AllocationChartAccessibility?

    func makeChartDescriptor() -> AXChartDescriptor {
        let shareFormat = shareFormat
        let xAxis = AXCategoricalDataAxisDescriptor(
            title: String(localized: holdingAxisTitle),
            categoryOrder: slices.map(\.label)
        )
        let yAxis = AXNumericDataAxisDescriptor(
            title: String(localized: shareAxisTitle),
            range: 0...1,
            gridlinePositions: []
        ) { share in
            share.formatted(shareFormat)
        }
        let dataSeries = AXDataSeriesDescriptor(
            name: title,
            isContinuous: false,
            dataPoints: zip(slices, shares).map { AXDataPoint(x: $0.label, y: $1) }
        )
        return AXChartDescriptor(
            title: title,
            summary: accessibility.map { String(localized: $0.summary) },
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [dataSeries]
        )
    }

    var shares: [Double] {
        let total = slices.reduce(0) { $0 + $1.value }
        guard total > 0 else { return slices.map { _ in 0 } }

        return slices.map { $0.value / total }
    }
}

private extension AllocationChartDescriptor {
    var title: String {
        accessibility.map { String(localized: $0.title) } ?? ""
    }

    var shareFormat: FloatingPointFormatStyle<Double>.Percent {
        .percent.precision(.fractionLength(0))
    }

    var holdingAxisTitle: LocalizedStringResource {
        .init("charts.axis.holding", bundle: .designSystem)
    }

    var shareAxisTitle: LocalizedStringResource {
        .init("charts.axis.share", bundle: .designSystem)
    }
}
