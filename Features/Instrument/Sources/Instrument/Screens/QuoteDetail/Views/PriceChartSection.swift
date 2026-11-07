//
//  PriceChartSection.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import SunUserInterface
import SwiftUI

struct PriceChartSection: View {
    @Environment(\.dimensions) private var dimensions

    let history: LoadState<PriceHistory, QuoteDetailIssue>
    let trading: TradingSnapshot
    let companyName: String
    let style: ChartStyle
    let range: HistoryRange
    let canShowCandles: Bool
    let onScrub: (Date?) -> Void
    let onSelectRange: (HistoryRange) -> Void
    let onSelectStyle: (ChartStyle) -> Void

    var body: some View {
        VStack(spacing: dimensions.spaceMedium) {
            chart
                .frame(minHeight: dimensions.chartHeight)
                .accessibilityIdentifier(InstrumentAccessibility.chart)

            ChartRangePicker(selection: range, onSelect: onSelectRange)
                .accessibilityIdentifier(InstrumentAccessibility.rangePicker)

            RevealContainer(isRevealed: canShowCandles) {
                FinanceSegmentedControl(
                    options: ChartStyle.allCases,
                    selection: style,
                    onSelect: onSelectStyle
                ) {
                    Text($0.title)
                }
                .accessibilityIdentifier(InstrumentAccessibility.chartStylePicker)
            }
        }
    }
}

private extension PriceChartSection {
    @ViewBuilder
    var chart: some View {
        switch (history, style) {
        case (.loaded(let history), .line):
            PriceLineChart(
                history.lineContent(trading: trading, companyName: companyName),
                onSelect: { onScrub($0?.date) }
            )
        case (.loaded(let history), .candles):
            CandlestickChart(
                history.candlestickContent(trading: trading, companyName: companyName),
                onSelect: { onScrub($0?.date) }
            )
        case (.idle, _), (.loading, _):
            ProgressView()
                .accessibilityLabel(Text("quoteDetail.chart.loading", bundle: .module))
        case (.failed, _):
            Text("quoteDetail.chart.unavailable", bundle: .module)
                .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
        }
    }
}

#if DEBUG
#Preview {
    ScrollView {
        VStack(spacing: 32) {
            PriceChartSection(
                history: .loaded(PreviewObjectPool().history(range: .day)),
                trading: PreviewObjectPool().trading,
                companyName: "Apple Inc.",
                style: .line,
                range: .day,
                canShowCandles: false,
                onScrub: { _ in },
                onSelectRange: { _ in },
                onSelectStyle: { _ in }
            )

            PriceChartSection(
                history: .loaded(PreviewObjectPool().history(range: .month)),
                trading: PreviewObjectPool().trading,
                companyName: "Apple Inc.",
                style: .candles,
                range: .month,
                canShowCandles: true,
                onScrub: { _ in },
                onSelectRange: { _ in },
                onSelectStyle: { _ in }
            )

            PriceChartSection(
                history: .loading,
                trading: TradingSnapshot(),
                companyName: "Apple Inc.",
                style: .line,
                range: .week,
                canShowCandles: false,
                onScrub: { _ in },
                onSelectRange: { _ in },
                onSelectStyle: { _ in }
            )

            PriceChartSection(
                history: .failed(.serviceUnavailable),
                trading: TradingSnapshot(),
                companyName: "Apple Inc.",
                style: .line,
                range: .year,
                canShowCandles: true,
                onScrub: { _ in },
                onSelectRange: { _ in },
                onSelectStyle: { _ in }
            )
        }
        .padding()
    }
}
#endif
