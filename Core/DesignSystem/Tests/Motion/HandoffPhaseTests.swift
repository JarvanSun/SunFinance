//
//  HandoffPhaseTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import CoreGraphics
import SunUserInterface
import Testing

@testable import DesignSystem

struct HandoffPhaseTests {
    @Test(
        arguments: [
            (HandoffPhase.arriving, 0.0, 0.98, 24, false),
            (.shown, 1.0, 1, 0, true),
            (.leaving, 0.0, 1.04, 0, false),
        ] as [(HandoffPhase, Double, CGFloat, CGFloat, Bool)]
    )
    func appearanceThenFollowsPhase(
        phase: HandoffPhase,
        opacity: Double,
        scale: CGFloat,
        offset: CGFloat,
        isInteractive: Bool
    ) {
        // Given
        let dimensions = DimensionStyle()

        // Then
        #expect(phase.opacity == opacity)
        #expect(phase.scale == scale)
        #expect(phase.verticalOffset(in: dimensions) == offset)
        #expect(phase.isInteractive == isInteractive)
    }
}
