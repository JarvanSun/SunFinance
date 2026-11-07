//
//  AllocationChartContent.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct AllocationChartContent: Sendable {
    public let slices: [AllocationSlice]
    public let accessibility: AllocationChartAccessibility?

    public init(slices: [AllocationSlice], accessibility: AllocationChartAccessibility? = nil) {
        self.slices = slices.filter { $0.value > 0 }
        self.accessibility = accessibility
    }
}
