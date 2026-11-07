//
//  PriceLineChartStyle.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct PriceLineChartStyle: Sendable {
    public let appearance: PriceLineChartAppearance
    public let isLive: Bool
    public let axisDate: (@Sendable (Date) -> String)?

    public init(
        appearance: PriceLineChartAppearance = .detailed,
        isLive: Bool = false,
        axisDate: (@Sendable (Date) -> String)? = nil
    ) {
        self.appearance = appearance
        self.isLive = isLive
        self.axisDate = axisDate
    }
}

extension PriceLineChartStyle {
    public static var detailed: Self { .init() }
}
