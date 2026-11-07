//
//  Metric.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct Metric: Identifiable {
    public let id: String
    public let label: LocalizedStringResource
    public let value: String
    public let trend: GainTrend?

    var valueColor: FinanceColor {
        trend?.color ?? .textPrimary
    }

    public init(
        id: String,
        label: LocalizedStringResource,
        value: String,
        trend: GainTrend? = nil
    ) {
        self.id = id
        self.label = label
        self.value = value
        self.trend = trend
    }
}
