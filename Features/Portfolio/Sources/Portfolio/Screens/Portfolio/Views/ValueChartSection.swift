//
//  ValueChartSection.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct ValueChartSection: View {
    @Environment(\.dimensions) private var dimensions

    let history: LoadState<PortfolioHistory, PortfolioIssue>
    let ranges: [HistoryRange]
    let range: HistoryRange
    let isLive: Bool
    let onScrub: (Date?) -> Void
    let onSelectRange: (HistoryRange) -> Void

    var body: some View {
        VStack(spacing: dimensions.spaceLargeSmall) {
            chart
                .frame(height: dimensions.chartHeight)
                .padding(.horizontal, dimensions.spaceLargeSmall)
                .accessibilityIdentifier(PortfolioAccessibility.valueChart)

            ChartRangePicker(ranges: ranges, selection: range, onSelect: onSelectRange)
                .padding(.horizontal, dimensions.spaceLargeSmall)
                .accessibilityIdentifier(PortfolioAccessibility.rangePicker)
        }
    }

    @ViewBuilder
    private var chart: some View {
        switch history {
        case .loaded(let history):
            PriceLineChart(
                PriceLineChartContent(
                    points: history.chartPoints,
                    baseline: history.baseline,
                    accessibility: history.chartAccessibility
                ),
                style: PriceLineChartStyle(
                    appearance: .hero,
                    isLive: isLive,
                    axisDate: history.range.axisDate
                ),
                onSelect: { onScrub($0?.date) }
            )
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed:
            Text("portfolio.chart.unavailable", bundle: .module)
                .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
