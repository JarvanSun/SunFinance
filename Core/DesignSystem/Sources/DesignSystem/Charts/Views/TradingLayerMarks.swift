//
//  TradingLayerMarks.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Charts
import SunUserInterface
import SwiftUI

struct TradingLayerMarks<Position: Plottable>: ChartContent {
    let layer: ChartTradingLayer
    let dimensions: any DimensionStyling
    let position: (Date) -> Position

    var body: some ChartContent {
        ForEach(layer.levels) { level in
            RuleMark(y: .value(PlotKey.value.rawValue, level.value))
                .foregroundStyle(FinanceColor.accent.color)
                .lineStyle(
                    StrokeStyle(lineWidth: dimensions.borderWidthSmall, dash: dimensions.chartDash)
                )
                .annotation(position: .top, alignment: .leading) {
                    Text(level.label)
                        .textStyle(FinanceColor.accent, FinanceFont.caption)
                }
        }

        ForEach(layer.markers, id: \.self) { marker in
            PointMark(
                x: .value(PlotKey.position.rawValue, position(marker.date)),
                y: .value(PlotKey.value.rawValue, marker.value)
            )
            .symbol(marker.kind.symbol)
            .symbolSize(dimensions.chartMarkerSize)
            .foregroundStyle(marker.kind.color.color)
        }
    }
}
