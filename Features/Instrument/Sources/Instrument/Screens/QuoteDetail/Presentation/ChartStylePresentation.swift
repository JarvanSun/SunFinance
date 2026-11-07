//
//  ChartStylePresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension ChartStyle {
    var title: LocalizedStringResource {
        switch self {
        case .line:
            .init("quoteDetail.chartStyle.line", bundle: .module)
        case .candles:
            .init("quoteDetail.chartStyle.candles", bundle: .module)
        }
    }
}
