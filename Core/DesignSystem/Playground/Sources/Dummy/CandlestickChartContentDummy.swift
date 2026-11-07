//
//  CandlestickChartContentDummy.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension CandlestickChartContent {
    static func dummy(for range: HistoryRange) -> CandlestickChartContent {
        .init(
            candles: ChartCandle.dummySeries(for: range),
            trading: .dummy(for: range),
            accessibility: .dummy
        )
    }
}
