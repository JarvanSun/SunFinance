//
//  AllocationPaletteTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import DesignSystem

struct AllocationPaletteTests {
    @Test func opacityThenFadesHoldingsByRankAndGreysNeutralParts() {
        // Given
        let big = AllocationSlice(id: "big", label: "Big", value: 300)
        let small = AllocationSlice(id: "small", label: "Small", value: 100)
        let cash = AllocationSlice(id: "cash", label: "Cash", value: 500, tone: .neutral)
        let palette = AllocationPalette(slices: [small, cash, big])

        // When
        let opacities = [big, small, cash].map(palette.opacity(of:))

        // Then
        #expect(opacities[0] == 1)
        #expect(abs(opacities[1] - 0.3) < 0.0001)
        #expect(opacities[2] == 0.28)
    }
}
