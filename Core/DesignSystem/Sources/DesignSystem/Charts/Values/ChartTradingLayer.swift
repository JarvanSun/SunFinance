//
//  ChartTradingLayer.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct ChartTradingLayer: Hashable, Sendable {
    public let markers: [ChartMarker]
    public let levels: [ChartLevel]

    var values: [Double] {
        markers.map(\.value) + levels.map(\.value)
    }

    public init(markers: [ChartMarker] = [], levels: [ChartLevel] = []) {
        self.markers = markers
        self.levels = levels
    }
}
