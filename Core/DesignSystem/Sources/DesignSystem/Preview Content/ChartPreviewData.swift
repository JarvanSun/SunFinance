//
//  ChartPreviewData.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import Foundation

struct ChartPreviewData {
    var allocation: [AllocationSlice] {
        [
            AllocationSlice(id: "AAPL", label: "AAPL", value: 3_197),
            AllocationSlice(id: "NVDA", label: "NVDA", value: 2_610),
            AllocationSlice(id: "SAP", label: "SAP", value: 3_425),
            AllocationSlice(id: "ALV", label: "ALV", value: 1_390),
            AllocationSlice(id: "cash", label: "Cash", value: 10_000, tone: .neutral),
        ]
    }

    var allocationChart: AllocationChartContent {
        AllocationChartContent(
            slices: allocation,
            accessibility: AllocationChartAccessibility(
                title: "Allocation",
                summary: "Four holdings and cash, cash the largest at 49 percent"
            )
        )
    }

    var rising: [ChartPoint] {
        wave(from: 212, slope: 0.12)
    }

    var falling: [ChartPoint] {
        wave(from: 232, slope: -0.1)
    }

    var flat: [ChartPoint] {
        wave(from: 220, slope: 0, amplitude: 0)
    }

    var candles: [ChartCandle] {
        candles(count: 60)
    }

    var longCandles: [ChartCandle] {
        candles(count: 400)
    }

    var candlePoints: [ChartPoint] {
        candles.map { ChartPoint(date: $0.date, value: $0.close) }
    }

    var accessibility: ChartAccessibility {
        ChartAccessibility(
            title: "Apple",
            summary: "Apple, one day, up 1.2 percent",
            valueDescription: { $0.formatted(.currency(code: "USD")) },
            dateDescription: { $0.formatted(date: .abbreviated, time: .shortened) }
        )
    }

    var axisDate: @Sendable (Date) -> String {
        { $0.formatted(date: .omitted, time: .shortened) }
    }

    func line(
        _ points: [ChartPoint],
        baseline: Double?,
        trading: ChartTradingLayer = .init()
    ) -> PriceLineChartContent {
        PriceLineChartContent(
            points: points,
            baseline: baseline,
            trading: trading,
            accessibility: accessibility
        )
    }

    func candleChart(
        _ candles: [ChartCandle],
        trading: ChartTradingLayer = .init()
    ) -> CandlestickChartContent {
        CandlestickChartContent(candles: candles, trading: trading, accessibility: accessibility)
    }

    func trading(on points: [ChartPoint]) -> ChartTradingLayer {
        let buy = points[points.count / 5]
        let sell = points[points.count * 7 / 10]
        return ChartTradingLayer(
            markers: [
                ChartMarker(date: buy.date, value: buy.value, kind: .buy),
                ChartMarker(date: sell.date, value: sell.value, kind: .sell),
            ],
            levels: [
                ChartLevel(id: "limit", value: (buy.value + sell.value) / 2, label: "Limit")
            ]
        )
    }

    private var start: Date { Date(timeIntervalSince1970: 1_793_000_000) }

    private func wave(
        from base: Double,
        slope: Double,
        amplitude: Double = 3
    ) -> [ChartPoint] {
        stride(from: 0, to: 100, by: 1).map { index in
            let value = base + Double(index) * slope + sin(Double(index) / 6) * amplitude
            return ChartPoint(date: start.addingTimeInterval(Double(index) * 300), value: value)
        }
    }

    private func candles(count: Int) -> [ChartCandle] {
        stride(from: 0, to: count, by: 1).map { index in
            let open = 200 + sin(Double(index) / 5) * 8
            let close = open + cos(Double(index) / 3) * 3
            return ChartCandle(
                date: start.addingTimeInterval(Double(index) * 86_400),
                open: open,
                high: max(open, close) + 1.5,
                low: min(open, close) - 1.5,
                close: close,
                volume: 1_000 + abs(sin(Double(index))) * 4_000
            )
        }
    }
}
#endif
