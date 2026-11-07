//
//  FieldEmphasisTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import CoreGraphics
import SunUserInterface
import Testing

@testable import DesignSystem

struct FieldEmphasisTests {
    @Test(arguments: [
        (false, false, FieldEmphasis.resting),
        (true, false, .focused),
        (false, true, .invalid),
        (true, true, .invalid),
    ])
    func initThenInvalidWinsOverFocus(isFocused: Bool, isInvalid: Bool, expected: FieldEmphasis) {
        // When
        let emphasis = FieldEmphasis(isFocused: isFocused, isInvalid: isInvalid)

        // Then
        #expect(emphasis == expected)
    }

    @Test(arguments: [
        (FieldEmphasis.resting, FinanceColor.separator, CGFloat(1)),
        (.focused, .accent, 2),
        (.invalid, .critical, 2),
    ])
    func borderThenStrengthensWithEmphasis(
        emphasis: FieldEmphasis,
        color: FinanceColor,
        width: CGFloat
    ) {
        // Given
        let dimensions = DimensionStyle()

        // Then
        #expect(emphasis.borderColor == color)
        #expect(emphasis.borderWidth(in: dimensions) == width)
    }
}
