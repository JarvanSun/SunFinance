//
//  ChartPoint.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct ChartPoint: Hashable, Sendable {
    public let date: Date
    public let value: Double

    public init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}
