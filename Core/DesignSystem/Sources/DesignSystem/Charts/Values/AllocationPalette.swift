//
//  AllocationPalette.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

public struct AllocationPalette: Sendable {
    private let slices: [AllocationSlice]

    public init(slices: [AllocationSlice]) {
        self.slices = slices
    }

    public func color(of slice: AllocationSlice) -> Color {
        switch slice.tone {
        case .holding: FinanceColor.accent.color.opacity(opacity(of: slice))
        case .neutral: FinanceColor.textSecondary.color.opacity(opacity(of: slice))
        }
    }

    func opacity(of slice: AllocationSlice) -> Double {
        switch slice.tone {
        case .holding: opacity(rank: holdingRank(of: slice))
        case .neutral: neutralOpacity
        }
    }
}

private extension AllocationPalette {
    var strongest: Double { 1 }

    var faintest: Double { 0.3 }

    var neutralOpacity: Double { 0.28 }

    var holdings: [AllocationSlice] {
        slices.filter { $0.tone == .holding }
    }

    func holdingRank(of slice: AllocationSlice) -> Int {
        holdings.sorted { $0.value > $1.value }.firstIndex(of: slice) ?? 0
    }

    func opacity(rank: Int) -> Double {
        let steps = max(holdings.count - 1, 1)
        return strongest - (strongest - faintest) * Double(rank) / Double(steps)
    }
}
