//
//  CandlestickChartContentDummy.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import Foundation

extension CandlestickChartContent {
    static func dummy(
        _ candles: [ChartCandle],
        trading: ChartTradingLayer = .init()
    ) -> CandlestickChartContent {
        .init(candles: candles, trading: trading, accessibility: .dummy)
    }
}
#endif
