//
//  MetricStrip.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public struct MetricStrip: View {
    @Environment(\.dimensions) private var dimensions

    private let metrics: [Metric]

    public init(_ metrics: [Metric]) {
        self.metrics = metrics
    }

    public var body: some View {
        Grid(
            alignment: .leading,
            horizontalSpacing: dimensions.spaceLargeSmall,
            verticalSpacing: dimensions.spaceLargeExtra
        ) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                GridRow {
                    ForEach(row) { metric in
                        tile(metric)
                    }
                }
            }
        }
        .padding(.horizontal, dimensions.spaceXSmall)
    }
}

private extension MetricStrip {
    var columns: Int { 2 }

    var valueMinimumScale: CGFloat { 0.75 }

    var rows: [[Metric]] {
        stride(from: 0, to: metrics.count, by: columns).map {
            Array(metrics[$0..<min($0 + columns, metrics.count)])
        }
    }

    func tile(_ metric: Metric) -> some View {
        VStack(alignment: .leading, spacing: dimensions.spaceXSmall) {
            Text(verbatim: metric.value)
                .textStyle(metric.valueColor, FinanceFont.figure)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(valueMinimumScale)

            Text(metric.label)
                .textStyle(FinanceColor.textSecondary, FinanceFont.caption)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
#Preview("Metric strip") {
    VStack(spacing: 16) {
        MetricStrip([
            Metric(id: "invested", label: "Invested", value: "€9,848.84"),
            Metric(id: "cash", label: "Cash", value: "€10,000.00"),
            Metric(id: "return", label: "Total return", value: "+€250.46", trend: .gain),
            Metric(id: "today", label: "Today", value: "-€12.40", trend: .loss),
        ])

        MetricStrip([
            Metric(id: "open", label: "Open", value: "$231.42"),
            Metric(id: "high", label: "Day high", value: "$233.10"),
            Metric(id: "low", label: "Day low", value: "$229.88"),
            Metric(id: "cap", label: "Market cap", value: "$3.45T"),
            Metric(id: "volume", label: "Volume", value: "48.2M"),
        ])

        MetricStrip([])
    }
    .padding()
    .background(FinanceColor.background.color)
}
#endif
