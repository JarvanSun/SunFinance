//
//  AllocationChartAccessibility.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct AllocationChartAccessibility: Sendable {
    public let title: LocalizedStringResource
    public let summary: LocalizedStringResource

    public init(title: LocalizedStringResource, summary: LocalizedStringResource) {
        self.title = title
        self.summary = summary
    }
}
