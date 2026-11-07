//
//  CandlestickChart.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Charts
import SunUserInterface
import SwiftUI

public struct CandlestickChart: View {
    @Environment(\.dimensions) private var dimensions
    @State private var selectedSlot: String?

    private let content: CandlestickChartContent
    private let series: CandleSeries
    private let onSelect: (ChartCandle?) -> Void

    public init(
        _ content: CandlestickChartContent,
        onSelect: @escaping (ChartCandle?) -> Void = { _ in }
    ) {
        self.content = content
        series = .init(content.candles, maximumCount: content.maximumCandleCount)
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(spacing: dimensions.spaceSmall) {
            Chart {
                ForEach(series.indices, id: \.self) { index in
                    candleMarks(for: series.candles[index], at: series.slot(at: index))
                }

                TradingLayerMarks(
                    layer: content.trading,
                    dimensions: dimensions,
                    position: series.slot(of:)
                )

                ForEach(selectedSlots, id: \.self) { slot in
                    RuleMark(x: .value(PlotKey.position.rawValue, slot))
                        .foregroundStyle(FinanceColor.separator.color)
                }
            }
            .chartYScale(domain: priceDomain)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(position: .trailing, values: .automatic(desiredCount: axisLabelCount)) {
                    AxisGridLine()
                        .foregroundStyle(FinanceColor.separator.color)

                    AxisValueLabel()
                        .font(FinanceFont.caption.font)
                }
            }
            .chartXSelection(value: $selectedSlot)
            .frame(height: dimensions.chartHeight)

            Chart {
                ForEach(series.indices, id: \.self) { index in
                    BarMark(
                        x: .value(PlotKey.position.rawValue, series.slot(at: index)),
                        y: .value(PlotKey.volume.rawValue, series.candles[index].volume),
                        width: .ratio(bodyWidthRatio)
                    )
                    .foregroundStyle(FinanceColor.textSecondary.color.opacity(volumeOpacity))
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: dimensions.volumeChartHeight)
        }
        .drawIn(key: series.candles.first?.date)
        .sensoryFeedback(.selection, trigger: selectedSlot)
        .onChange(of: selectedSlot) { _, slot in onSelect(series.candle(atSlot: slot)) }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(content.accessibility.summary))
        .accessibilityChartDescriptor(
            PriceChartDescriptor(points: series.closePoints, accessibility: content.accessibility)
        )
    }
}

private extension CandlestickChart {
    var axisLabelCount: Int { 4 }

    var volumeOpacity: Double { 0.3 }

    var bodyWidthRatio: Double { 0.6 }

    var selectedSlots: [String] {
        selectedSlot.map { [$0] } ?? []
    }

    var priceDomain: ClosedRange<Double> {
        series.scale.domain(including: content.trading.values)
    }

    @ChartContentBuilder
    func candleMarks(for candle: ChartCandle, at slot: String) -> some ChartContent {
        RuleMark(
            x: .value(PlotKey.position.rawValue, slot),
            yStart: .value(PlotKey.low.rawValue, candle.low),
            yEnd: .value(PlotKey.high.rawValue, candle.high)
        )
        .foregroundStyle(candle.trend.color.color)
        .lineStyle(StrokeStyle(lineWidth: dimensions.borderWidthSmall))

        RectangleMark(
            x: .value(PlotKey.position.rawValue, slot),
            yStart: .value(PlotKey.value.rawValue, min(candle.open, candle.close)),
            yEnd: .value(PlotKey.value.rawValue, max(candle.open, candle.close)),
            width: .ratio(bodyWidthRatio)
        )
        .foregroundStyle(candle.trend.color.color)
    }
}

private extension CandlestickChartContent {
    var maximumCandleCount: Int { 90 }
}

#if DEBUG
#Preview {
    ScrollView {
        VStack(spacing: 32) {
            CandlestickChart(.dummy(ChartCandle.dummyCandles))

            CandlestickChart(
                .dummy(
                    ChartCandle.dummyCandles,
                    trading: .dummy(on: ChartPoint.dummyCandlePoints)
                )
            )

            CandlestickChart(.dummy(ChartCandle.dummyLongCandles))

            CandlestickChart(.dummy([]))
        }
        .padding()
    }
}
#endif
