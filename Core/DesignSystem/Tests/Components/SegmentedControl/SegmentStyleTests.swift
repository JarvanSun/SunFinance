//
//  SegmentStyleTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import CoreGraphics
import SunUserInterface
import SwiftUI
import Testing

@testable import DesignSystem

struct SegmentStyleTests {
    @Test(arguments: [
        (SegmentStyle.prominent, true, FinanceColor.textOnAccent, FinanceFont.headline),
        (.prominent, false, .textSecondary, .callout),
        (.quiet, true, .background, .headline),
        (.quiet, false, .textPrimary, .callout),
    ])
    func labelThenStandsOutOnlyWhenSelected(
        style: SegmentStyle,
        isSelected: Bool,
        foreground: FinanceColor,
        font: FinanceFont
    ) {
        // Then
        #expect(style.foreground(isSelected: isSelected) == foreground)
        #expect(style.font(isSelected: isSelected) == font)
    }

    @Test func trackWhenProminentThenIsFilledAndPadded() {
        // Given
        let dimensions = DimensionStyle()

        // Then
        #expect(SegmentStyle.prominent.capsuleColor == .accent)
        #expect(SegmentStyle.prominent.trackColor == FinanceColor.surfaceElevated.color)
        #expect(SegmentStyle.prominent.trackPadding(in: dimensions) == dimensions.spaceXSmall)
    }

    @Test func trackWhenQuietThenIsClearAndFlush() {
        // Given
        let dimensions = DimensionStyle()

        // Then
        #expect(SegmentStyle.quiet.capsuleColor == .textPrimary)
        #expect(SegmentStyle.quiet.trackColor == .clear)
        #expect(SegmentStyle.quiet.trackPadding(in: dimensions) == 0)
    }

    @Test(arguments: [
        (SegmentStyle.prominent, CGFloat(100), CGFloat?.none),
        (.quiet, 90, 32),
    ])
    func capsuleThenQuietHugsItsLabel(style: SegmentStyle, width: CGFloat, height: CGFloat?) {
        // Given
        let dimensions = DimensionStyle()

        // When
        let capsuleWidth = style.capsuleWidth(segmentWidth: 100)

        // Then
        #expect(abs(capsuleWidth - width) < 0.0001)
        #expect(style.capsuleHeight(in: dimensions) == height)
    }
}
