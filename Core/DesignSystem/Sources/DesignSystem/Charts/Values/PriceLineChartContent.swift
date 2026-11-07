//
//  PriceLineChartContent.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct PriceLineChartContent: Sendable {
    public let points: [ChartPoint]
    public let baseline: Double?
    public let trading: ChartTradingLayer
    public let accessibility: ChartAccessibility

    public init(
        points: [ChartPoint],
        baseline: Double?,
        trading: ChartTradingLayer = .init(),
        accessibility: ChartAccessibility
    ) {
        self.points = points
        self.baseline = baseline
        self.trading = trading
        self.accessibility = accessibility
    }
}
