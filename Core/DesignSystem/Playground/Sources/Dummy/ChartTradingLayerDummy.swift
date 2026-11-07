//
//  ChartTradingLayerDummy.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension ChartTradingLayer {
    static func dummy(for range: HistoryRange) -> ChartTradingLayer {
        let points = ChartPoint.dummySeries(for: range)
        let buy = points[points.count / 10]
        let sell = points[points.count * 3 / 4]
        return .init(
            markers: [
                ChartMarker(date: buy.date, value: buy.value, kind: .buy),
                ChartMarker(date: sell.date, value: sell.value, kind: .sell),
            ],
            levels: [ChartLevel(id: "limit", value: 215, label: "Limit 215.00")]
        )
    }
}
