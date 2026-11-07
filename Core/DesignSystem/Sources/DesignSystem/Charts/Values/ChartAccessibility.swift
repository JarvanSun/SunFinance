//
//  ChartAccessibility.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct ChartAccessibility: Sendable {
    public let title: LocalizedStringResource
    public let summary: LocalizedStringResource
    public let valueDescription: @Sendable (Double) -> String
    public let dateDescription: @Sendable (Date) -> String

    public init(
        title: LocalizedStringResource,
        summary: LocalizedStringResource,
        valueDescription: @escaping @Sendable (Double) -> String,
        dateDescription: @escaping @Sendable (Date) -> String
    ) {
        self.title = title
        self.summary = summary
        self.valueDescription = valueDescription
        self.dateDescription = dateDescription
    }
}
