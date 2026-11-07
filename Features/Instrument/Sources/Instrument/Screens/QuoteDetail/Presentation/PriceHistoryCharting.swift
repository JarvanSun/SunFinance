//
//  PriceHistoryCharting.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension PriceHistory {
    var chartPoints: [ChartPoint] {
        candles.map { ChartPoint(date: $0.start, value: $0.close.doubleValue) }
    }

    var chartCandles: [ChartCandle] {
        candles.map {
            ChartCandle(
                date: $0.start,
                open: $0.open.doubleValue,
                high: $0.high.doubleValue,
                low: $0.low.doubleValue,
                close: $0.close.doubleValue,
                volume: Double($0.volume)
            )
        }
    }

    var chartBaseline: Double? {
        baseline?.doubleValue
    }

    func lineContent(trading: TradingSnapshot, companyName: String) -> PriceLineChartContent {
        PriceLineChartContent(
            points: chartPoints,
            baseline: chartBaseline,
            trading: trading.chartLayer(for: self),
            accessibility: chartAccessibility(companyName: companyName)
        )
    }

    func candlestickContent(
        trading: TradingSnapshot,
        companyName: String
    ) -> CandlestickChartContent {
        CandlestickChartContent(
            candles: chartCandles,
            trading: trading.chartLayer(for: self),
            accessibility: chartAccessibility(companyName: companyName)
        )
    }

    func chartAccessibility(companyName: String) -> ChartAccessibility {
        let currency = currency.rawValue
        let style = range.momentStyle
        return ChartAccessibility(
            title: .init("quoteDetail.chart.title \(companyName)", bundle: .module),
            summary: chartSummary(companyName: companyName),
            valueDescription: { $0.formatted(.currency(code: currency)) },
            dateDescription: { $0.formatted(style) }
        )
    }
}

private extension PriceHistory {
    func chartSummary(companyName: String) -> LocalizedStringResource {
        switch candles.last.flatMap({ change(to: $0.close) }) {
        case .some(let change):
            summary(companyName: companyName, change: change)
        case nil:
            .init(
                "quoteDetail.chart.summary.empty \(companyName) \(range.accessibilityTitle)",
                bundle: .module
            )
        }
    }

    func summary(companyName: String, change: PriceChange) -> LocalizedStringResource {
        let percent = change.percent.formatted(.signedPercent)
        let start = change.start.formatted()
        let end = change.end.formatted()
        let period = range.accessibilityTitle
        return .init(
            "quoteDetail.chart.summary \(companyName) \(period) \(percent) \(start) \(end)",
            bundle: .module
        )
    }
}

private extension Decimal {
    var doubleValue: Double {
        NSDecimalNumber(decimal: self).doubleValue
    }
}
