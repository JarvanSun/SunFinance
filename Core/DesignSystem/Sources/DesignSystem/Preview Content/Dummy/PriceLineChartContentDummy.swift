//
//  PriceLineChartContentDummy.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import Foundation

extension PriceLineChartContent {
    static func dummy(
        _ points: [ChartPoint],
        baseline: Double?,
        trading: ChartTradingLayer = .init()
    ) -> PriceLineChartContent {
        .init(points: points, baseline: baseline, trading: trading, accessibility: .dummy)
    }
}
#endif
