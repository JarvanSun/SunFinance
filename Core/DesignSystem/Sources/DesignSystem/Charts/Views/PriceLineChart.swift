//
//  PriceLineChart.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Charts
import SunUserInterface
import SwiftUI

public struct PriceLineChart: View {
    @Environment(\.dimensions) private var dimensions
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedIndex: Int?

    private let content: PriceLineChartContent
    private let style: PriceLineChartStyle
    private let series: ChartSeries
    private let scale: ValueScale
    private let onSelect: (ChartPoint?) -> Void

    public init(
        _ content: PriceLineChartContent,
        style: PriceLineChartStyle = .detailed,
        onSelect: @escaping (ChartPoint?) -> Void = { _ in }
    ) {
        self.content = content
        self.style = style
        series = ChartSeries(drawing: content.points, count: ChartSeries.morphPointCount)
        scale = ValueScale(values: content.points.map(\.value))
        self.onSelect = onSelect
    }

    public var body: some View {
        Chart {
            ForEach(series.indices, id: \.self) { index in
                LineMark(
                    x: .value(PlotKey.position.rawValue, index),
                    y: .value(PlotKey.value.rawValue, series.points[index].value),
                    series: .value(PlotKey.layer.rawValue, PlotLayer.line.rawValue)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(lineColor.color)
                .lineStyle(lineStroke)
            }

            ForEach(fadedIndices, id: \.self) { index in
                LineMark(
                    x: .value(PlotKey.position.rawValue, index),
                    y: .value(PlotKey.value.rawValue, series.points[index].value),
                    series: .value(PlotKey.layer.rawValue, PlotLayer.aheadMask.rawValue)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(FinanceColor.background.color)
                .lineStyle(maskStroke)

                LineMark(
                    x: .value(PlotKey.position.rawValue, index),
                    y: .value(PlotKey.value.rawValue, series.points[index].value),
                    series: .value(PlotKey.layer.rawValue, PlotLayer.ahead.rawValue)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(FinanceColor.textSecondary.color.opacity(aheadOpacity))
                .lineStyle(lineStroke)
            }

            ForEach(baselineValues, id: \.self) { value in
                RuleMark(y: .value(PlotKey.value.rawValue, value))
                    .foregroundStyle(FinanceColor.textSecondary.color.opacity(baselineOpacity))
                    .lineStyle(dashStroke)
            }

            TradingLayerMarks(layer: content.trading, dimensions: dimensions, position: position)

            ForEach(livePoints, id: \.offset) { live in
                PointMark(
                    x: .value(PlotKey.position.rawValue, live.offset),
                    y: .value(PlotKey.value.rawValue, live.element.value)
                )
                .symbolSize(.zero)
                .annotation(position: .overlay) {
                    LiveDot(color: lineColor)
                }
            }

            ForEach(selectedPoints, id: \.offset) { selected in
                RuleMark(x: .value(PlotKey.position.rawValue, selected.offset))
                    .foregroundStyle(lineColor.color.opacity(selectionRuleOpacity))
                    .lineStyle(StrokeStyle(lineWidth: dimensions.borderWidthSmall))

                PointMark(
                    x: .value(PlotKey.position.rawValue, selected.offset),
                    y: .value(PlotKey.value.rawValue, selected.element.value)
                )
                .symbolSize(.zero)
                .annotation(position: .overlay) {
                    SelectionDot(color: lineColor)
                }
            }
        }
        .chartXScale(
            domain: positionDomain,
            range: .plotDimension(startPadding: .zero, endPadding: endPadding)
        )
        .chartYScale(domain: valueDomain)
        .chartYAxis {
            switch style.appearance {
            case .detailed:
                AxisMarks(position: .trailing, values: .automatic(desiredCount: axisLabelCount)) {
                    AxisGridLine()
                        .foregroundStyle(FinanceColor.separator.color.opacity(gridOpacity))

                    AxisValueLabel()
                        .font(FinanceFont.caption.font)
                        .foregroundStyle(FinanceColor.textSecondary.color)
                }
            case .hero:
                AxisMarks(position: .trailing, values: scale.guideValues) {
                    AxisGridLine()
                        .foregroundStyle(FinanceColor.separator.color)

                    AxisValueLabel(
                        format: guideFormat,
                        anchor: .bottomTrailing,
                        horizontalSpacing: .zero,
                        verticalSpacing: dimensions.spaceXSmall
                    )
                    .font(FinanceFont.caption.font)
                    .foregroundStyle(FinanceColor.textSecondary.color)
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: dateTickIndices) { value in
                AxisValueLabel(anchor: .topLeading) {
                    Text(verbatim: dateLabel(at: value))
                        .font(FinanceFont.caption.font)
                        .foregroundStyle(FinanceColor.textSecondary.color)
                }
            }
        }
        .chartXSelection(value: $selectedIndex)
        .animation(FinanceMotion.settle.animation(reduceMotion: reduceMotion), value: series)
        .drawIn(key: series.points.isEmpty)
        .frame(height: dimensions.chartHeight)
        .sensoryFeedback(.selection, trigger: selectedIndex)
        .onChange(of: selectedIndex) { _, index in onSelect(series.point(at: index)) }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(content.accessibility.summary))
        .accessibilityChartDescriptor(
            PriceChartDescriptor(points: series.points, accessibility: content.accessibility)
        )
    }
}

// MARK: - Private

private extension PriceLineChart {
    var axisLabelCount: Int { 4 }

    var dateTickCount: Int { 3 }

    var aheadOpacity: Double { 0.45 }

    var baselineOpacity: Double { 0.5 }

    var gridOpacity: Double { 0.6 }

    var selectionRuleOpacity: Double { 0.5 }

    var guideFormat: FloatingPointFormatStyle<Double> {
        .number.precision(.fractionLength(0))
    }

    var lineStroke: StrokeStyle {
        StrokeStyle(lineWidth: dimensions.chartLineWidth, lineCap: .round, lineJoin: .round)
    }

    var dashStroke: StrokeStyle {
        StrokeStyle(lineWidth: dimensions.borderWidthSmall, dash: dimensions.chartDash)
    }

    var maskStroke: StrokeStyle {
        StrokeStyle(lineWidth: dimensions.chartScrubMaskWidth, lineCap: .butt, lineJoin: .round)
    }

    var positionDomain: ClosedRange<Int> {
        0...max(series.points.count - 1, 1)
    }

    var lineColor: FinanceColor {
        trend.color
    }

    var trend: GainTrend {
        switch (content.baseline ?? series.first?.value, series.last?.value) {
        case (.some(let start), .some(let end)):
            GainTrend(from: start, to: end)
        case (nil, _), (_, nil):
            .unchanged
        }
    }

    var baselineValues: [Double] {
        switch (style.appearance, content.baseline) {
        case (.detailed, .some(let baseline)):
            [baseline]
        case (.detailed, nil), (.hero, _):
            []
        }
    }

    var valueDomain: ClosedRange<Double> {
        scale.domain(including: baselineValues + content.trading.values + scale.guideValues)
    }

    var endPadding: CGFloat {
        style.isLive ? dimensions.chartLiveEndPadding : .zero
    }

    var dateTickIndices: [Int] {
        switch style.axisDate {
        case .some:
            series.tickIndices(count: dateTickCount)
        case nil:
            []
        }
    }

    var fadedIndices: [Int] {
        guard let selectedIndex, series.points.indices.contains(selectedIndex) else { return [] }

        return Array(selectedIndex..<series.points.count)
    }

    var livePoints: [(offset: Int, element: ChartPoint)] {
        guard style.isLive, selectedIndex == nil, let last = series.points.last else { return [] }

        return [(series.points.count - 1, last)]
    }

    var selectedPoints: [(offset: Int, element: ChartPoint)] {
        selectedIndex.flatMap { index in series.point(at: index).map { [(index, $0)] } } ?? []
    }

    func position(of date: Date) -> Int {
        series.index(of: date) ?? .zero
    }

    func dateLabel(at value: AxisValue) -> String {
        switch (value.as(Int.self).flatMap(series.point(at:)), style.axisDate) {
        case (.some(let point), .some(let axisDate)):
            axisDate(point.date)
        case (nil, _), (_, nil):
            ""
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview {
    ScrollView {
        VStack(spacing: 32) {
            PriceLineChart(ChartPreviewData.line(ChartPreviewData.rising, baseline: 210))

            PriceLineChart(
                ChartPreviewData.line(
                    ChartPreviewData.falling,
                    baseline: 230,
                    trading: ChartPreviewData.trading(on: ChartPreviewData.falling)
                )
            )

            PriceLineChart(ChartPreviewData.line(ChartPreviewData.flat, baseline: 220))

            PriceLineChart(
                ChartPreviewData.line(ChartPreviewData.rising, baseline: nil),
                style: PriceLineChartStyle(appearance: .hero, axisDate: ChartPreviewData.axisDate)
            )

            PriceLineChart(
                ChartPreviewData.line(ChartPreviewData.falling, baseline: nil),
                style: PriceLineChartStyle(
                    appearance: .hero,
                    isLive: true,
                    axisDate: ChartPreviewData.axisDate
                )
            )

            PriceLineChart(ChartPreviewData.line([], baseline: nil))
        }
        .padding()
    }
}
#endif
