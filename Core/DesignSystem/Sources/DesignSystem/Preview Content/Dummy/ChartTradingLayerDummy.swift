//
//  ChartTradingLayerDummy.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import Foundation

extension ChartTradingLayer {
    static func dummy(on points: [ChartPoint]) -> ChartTradingLayer {
        let buy = points[points.count / 5]
        let sell = points[points.count * 7 / 10]
        return .init(
            markers: [
                ChartMarker(date: buy.date, value: buy.value, kind: .buy),
                ChartMarker(date: sell.date, value: sell.value, kind: .sell),
            ],
            levels: [
                ChartLevel(id: "limit", value: (buy.value + sell.value) / 2, label: "Limit")
            ]
        )
    }
}
#endif
