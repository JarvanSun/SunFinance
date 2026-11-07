//
//  ChartMarkerPresentation.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Charts

extension ChartMarker.Kind {
    var symbol: BasicChartSymbolShape {
        switch self {
        case .buy:
            .triangle
        case .sell:
            .diamond
        }
    }

    var color: FinanceColor {
        switch self {
        case .buy:
            .gain
        case .sell:
            .loss
        }
    }
}
