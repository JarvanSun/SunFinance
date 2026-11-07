//
//  PriceLineChartContentDummy.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension PriceLineChartContent {
    static func dummyLine(for range: HistoryRange) -> PriceLineChartContent {
        .init(
            points: ChartPoint.dummySeries(for: range),
            baseline: 205,
            trading: .dummy(for: range),
            accessibility: .dummy
        )
    }

    static func dummyValue(for range: HistoryRange) -> PriceLineChartContent {
        .init(
            points: ChartPoint.dummySeries(for: range),
            baseline: nil,
            accessibility: .dummy
        )
    }
}
