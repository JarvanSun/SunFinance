//
//  ChartGalleryView.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct ChartGalleryView: View {
    @Environment(\.dimensions) private var dimensions
    @State private var range = HistoryRange.day
    @State private var selected: ChartPoint?
    @State private var selectedSlice: AllocationSlice.ID?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: dimensions.spaceXLarge) {
                    Text(verbatim: selectionText)
                        .textStyle(FinanceColor.textSecondary, FinanceFont.callout)

                    PriceLineChart(SampleSeries.line(for: range), onSelect: { selected = $0 })

                    ChartRangePicker(selection: range, onSelect: { range = $0 })

                    caption("Hero, live, with time labels")

                    PriceLineChart(
                        SampleSeries.value(for: range),
                        style: PriceLineChartStyle(
                            appearance: .hero,
                            isLive: true,
                            axisDate: SampleSeries.axisDate
                        )
                    )

                    caption("Candles with fills and a limit")

                    CandlestickChart(SampleSeries.candleChart(for: range))

                    caption("Allocation")

                    AllocationChart(
                        SampleSeries.allocation,
                        selection: selectedSlice,
                        onSelect: { selectedSlice = $0 }
                    ) { slice in
                        Text(verbatim: slice?.label ?? "Total")
                            .textStyle(FinanceColor.textPrimary, FinanceFont.headline)
                    }
                }
                .padding()
            }
            .navigationTitle(Text(verbatim: "Charts"))
        }
    }
}

private extension ChartGalleryView {
    var selectionText: String {
        switch selected {
        case .some(let point):
            let value = point.value.formatted(.currency(code: "USD"))
            return "\(value) at \(point.date.formatted(date: .omitted, time: .shortened))"
        case nil:
            return "Drag across the chart"
        }
    }

    func caption(_ text: String) -> some View {
        Text(verbatim: text)
            .textStyle(FinanceColor.textSecondary, FinanceFont.caption)
    }
}
