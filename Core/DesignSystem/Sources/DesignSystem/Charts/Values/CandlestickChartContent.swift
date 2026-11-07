//
//  CandlestickChartContent.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct CandlestickChartContent: Sendable {
    public let candles: [ChartCandle]
    public let trading: ChartTradingLayer
    public let accessibility: ChartAccessibility

    public init(
        candles: [ChartCandle],
        trading: ChartTradingLayer = .init(),
        accessibility: ChartAccessibility
    ) {
        self.candles = candles
        self.trading = trading
        self.accessibility = accessibility
    }
}
