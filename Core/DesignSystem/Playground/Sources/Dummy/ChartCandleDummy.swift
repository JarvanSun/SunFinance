//
//  ChartCandleDummy.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension ChartCandle {
    static func dummySeries(for range: HistoryRange) -> [ChartCandle] {
        ChartPoint.dummySeries(for: range).enumerated().map { index, point in
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
}
