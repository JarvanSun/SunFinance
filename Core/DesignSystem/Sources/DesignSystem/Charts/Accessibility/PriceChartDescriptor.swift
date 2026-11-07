//
//  PriceChartDescriptor.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Accessibility
import Foundation
import SwiftUI

struct PriceChartDescriptor: AXChartDescriptorRepresentable {
    let points: [ChartPoint]
    let accessibility: ChartAccessibility

    func makeChartDescriptor() -> AXChartDescriptor {
        let points = points
        let dateDescription = accessibility.dateDescription
        let values = points.map(\.value)
        let xAxis = AXNumericDataAxisDescriptor(
            title: String(localized: timeAxisTitle),
            range: 0...Double(max(points.count - 1, 1)),
            gridlinePositions: []
        ) { position in
            let index = Int(position.rounded())
            return points.indices.contains(index) ? dateDescription(points[index].date) : ""
        }
        let yAxis = AXNumericDataAxisDescriptor(
            title: String(localized: valueAxisTitle),
            range: (values.min() ?? 0)...(values.max() ?? 1),
            gridlinePositions: [],
            valueDescriptionProvider: accessibility.valueDescription
        )
        let dataSeries = AXDataSeriesDescriptor(
            name: String(localized: accessibility.title),
            isContinuous: true,
            dataPoints: points.enumerated().map {
                AXDataPoint(x: Double($0.offset), y: $0.element.value)
            }
        )
        return AXChartDescriptor(
            title: String(localized: accessibility.title),
            summary: String(localized: accessibility.summary),
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [dataSeries]
        )
    }
}

private extension PriceChartDescriptor {
    var timeAxisTitle: LocalizedStringResource {
        .init("charts.axis.time", bundle: .module)
    }

    var valueAxisTitle: LocalizedStringResource {
        .init("charts.axis.value", bundle: .module)
    }
}
