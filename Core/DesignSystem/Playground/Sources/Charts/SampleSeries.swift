//
//  SampleSeries.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

struct SampleSeries {
    var allocation: AllocationChartContent {
        AllocationChartContent(
            slices: [
                AllocationSlice(id: "AAPL", label: "AAPL", value: 3_197),
                AllocationSlice(id: "NVDA", label: "NVDA", value: 2_610),
                AllocationSlice(id: "SAP", label: "SAP", value: 3_425),
                AllocationSlice(id: "cash", label: "Cash", value: 10_000, tone: .neutral),
            ],
            accessibility: AllocationChartAccessibility(
                title: "Allocation",
                summary: "Three holdings and cash"
            )
        )
    }

    var axisDate: @Sendable (Date) -> String {
        { $0.formatted(date: .omitted, time: .shortened) }
    }

    func line(for range: HistoryRange) -> PriceLineChartContent {
        PriceLineChartContent(
            points: points(for: range),
            baseline: 205,
            trading: trading(for: range),
            accessibility: accessibility
        )
    }

    func value(for range: HistoryRange) -> PriceLineChartContent {
        PriceLineChartContent(
            points: points(for: range),
            baseline: nil,
            accessibility: accessibility
        )
    }

    func candleChart(for range: HistoryRange) -> CandlestickChartContent {
        CandlestickChartContent(
            candles: candles(for: range),
            trading: trading(for: range),
            accessibility: accessibility
        )
    }
}

private extension SampleSeries {
    var accessibility: ChartAccessibility {
        ChartAccessibility(
            title: "Sample",
            summary: "A sample price series",
            valueDescription: { $0.formatted(.currency(code: "USD")) },
            dateDescription: { $0.formatted(date: .abbreviated, time: .shortened) }
        )
    }

    func points(for range: HistoryRange) -> [ChartPoint] {
        let count = pointCount(for: range)
        let start = Date(timeIntervalSince1970: 1_793_000_000)
        return (0..<count).map { index in
            let progress = Double(index) / Double(count)
            let value = 200 + sin(progress * 9) * 12 + sin(progress * 47) * 3 + progress * 18
            return ChartPoint(date: start.addingTimeInterval(Double(index) * 300), value: value)
        }
    }

    func candles(for range: HistoryRange) -> [ChartCandle] {
        points(for: range).enumerated().map { index, point in
            let close = point.value + sin(Double(index)) * 2
            return ChartCandle(
                date: point.date,
                open: point.value,
                high: max(point.value, close) + 1.5,
                low: min(point.value, close) - 1.5,
                close: close,
                volume: 1_000 + abs(cos(Double(index) / 3)) * 5_000
            )
        }
    }

    func trading(for range: HistoryRange) -> ChartTradingLayer {
        let points = points(for: range)
        let buy = points[points.count / 10]
        let sell = points[points.count * 3 / 4]
        return ChartTradingLayer(
            markers: [
                ChartMarker(date: buy.date, value: buy.value, kind: .buy),
                ChartMarker(date: sell.date, value: sell.value, kind: .sell),
            ],
            levels: [ChartLevel(id: "limit", value: 215, label: "Limit 215.00")]
        )
    }

    func pointCount(for range: HistoryRange) -> Int {
        switch range {
        case .day:
            78
        case .week:
            130
        case .month:
            154
        case .threeMonths:
            63
        case .year:
            252
        case .fiveYears:
            1_260
        }
    }
}
