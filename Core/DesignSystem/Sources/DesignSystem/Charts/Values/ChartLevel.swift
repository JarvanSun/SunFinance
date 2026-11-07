//
//  ChartLevel.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct ChartLevel: Identifiable, Hashable, Sendable {
    public let id: String
    public let value: Double
    public let label: LocalizedStringResource

    public init(id: String, value: Double, label: LocalizedStringResource) {
        self.id = id
        self.value = value
        self.label = label
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.value == rhs.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(value)
    }
}
