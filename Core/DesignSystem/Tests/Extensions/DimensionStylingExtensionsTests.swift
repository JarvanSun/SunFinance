//
//  DimensionStylingExtensionsTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import CoreGraphics
import DesignSystem
import SunUserInterface
import Testing

struct DimensionStylingExtensionsTests {
    @Test func tokensWhenNotOverriddenThenUseDefaults() {
        // Given
        let dimensions = DimensionStyle()

        // Then
        #expect(dimensions.minimumTapTarget == 44)
        #expect(dimensions.placeholderMaximumWidth == 320)
        #expect(dimensions.placeholderMinimumHeight == 240)
        #expect(dimensions.headerPlaceholderHeight == 64)
        #expect(dimensions.formMaximumWidth == 460)
        #expect(dimensions.heroAmountSpacing == 2)
        #expect(dimensions.heroAmountRowSpacing == 1)
        #expect(dimensions.heroAmountKerning == -1)
        #expect(dimensions.chartHeight == 240)
        #expect(dimensions.volumeChartHeight == 44)
        #expect(dimensions.chartLineWidth == 2)
        #expect(dimensions.chartMarkerSize == 80)
        #expect(dimensions.chartDashLength == 4)
        #expect(dimensions.chartSliceGap == 1.5)
        #expect(dimensions.chartLiveDotSize == 10)
        #expect(dimensions.chartLiveEndPadding == 16)
        #expect(dimensions.chartSelectionDotSize == 12)
        #expect(dimensions.chartSelectionDotBorderWidth == 3)
        #expect(dimensions.chartSelectionShadowRadius == 4)
        #expect(dimensions.chartScrubMaskWidth == 4)
        #expect(dimensions.segmentCapsuleHeight == 32)
        #expect(dimensions.slideKnobSize == 56)
        #expect(dimensions.slideKnobShadowRadius == 4)
        #expect(dimensions.completionBadgeSize == 96)
        #expect(dimensions.completionBadgeRingWidth == 4)
        #expect(dimensions.handoffRiseDistance == 24)
        #expect(dimensions.shakeDistance == 10)
        #expect(dimensions.cornerRadiusSurface == 22)
        #expect(dimensions.swatchHeight == 40)
        #expect(dimensions.actionButtonHeight == 56)
    }

    @Test func tokensWhenOverriddenThenUseOverride() {
        // Given
        let override: CGFloat = 7
        let tokens = DimensionTokens(
            tokens: Dictionary(uniqueKeysWithValues: appTokens.map { ($0, override) })
        )

        // When
        let dimensions = DimensionStyle(tokens: tokens)

        // Then
        #expect(dimensions.minimumTapTarget == override)
        #expect(dimensions.placeholderMaximumWidth == override)
        #expect(dimensions.placeholderMinimumHeight == override)
        #expect(dimensions.headerPlaceholderHeight == override)
        #expect(dimensions.formMaximumWidth == override)
        #expect(dimensions.heroAmountSpacing == override)
        #expect(dimensions.heroAmountRowSpacing == override)
        #expect(dimensions.heroAmountKerning == override)
        #expect(dimensions.chartHeight == override)
        #expect(dimensions.volumeChartHeight == override)
        #expect(dimensions.chartLineWidth == override)
        #expect(dimensions.chartMarkerSize == override)
        #expect(dimensions.chartDashLength == override)
        #expect(dimensions.chartSliceGap == override)
        #expect(dimensions.chartLiveDotSize == override)
        #expect(dimensions.chartLiveEndPadding == override)
        #expect(dimensions.chartSelectionDotSize == override)
        #expect(dimensions.chartSelectionDotBorderWidth == override)
        #expect(dimensions.chartSelectionShadowRadius == override)
        #expect(dimensions.chartScrubMaskWidth == override)
        #expect(dimensions.segmentCapsuleHeight == override)
        #expect(dimensions.slideKnobSize == override)
        #expect(dimensions.slideKnobShadowRadius == override)
        #expect(dimensions.completionBadgeSize == override)
        #expect(dimensions.completionBadgeRingWidth == override)
        #expect(dimensions.handoffRiseDistance == override)
        #expect(dimensions.shakeDistance == override)
        #expect(dimensions.cornerRadiusSurface == override)
        #expect(dimensions.swatchHeight == override)
        #expect(dimensions.actionButtonHeight == override)
    }
}

private extension DimensionStylingExtensionsTests {
    var appTokens: [DimensionToken] {
        [
            .minimumTapTarget,
            .placeholderMaximumWidth,
            .placeholderMinimumHeight,
            .headerPlaceholderHeight,
            .formMaximumWidth,
            .heroAmountSpacing,
            .heroAmountRowSpacing,
            .heroAmountKerning,
            .chartHeight,
            .volumeChartHeight,
            .chartLineWidth,
            .chartMarkerSize,
            .chartDashLength,
            .chartSliceGap,
            .chartLiveDotSize,
            .chartLiveEndPadding,
            .chartSelectionDotSize,
            .chartSelectionDotBorderWidth,
            .chartSelectionShadowRadius,
            .chartScrubMaskWidth,
            .segmentCapsuleHeight,
            .slideKnobSize,
            .slideKnobShadowRadius,
            .completionBadgeSize,
            .completionBadgeRingWidth,
            .handoffRiseDistance,
            .shakeDistance,
            .cornerRadiusSurface,
            .swatchHeight,
            .actionButtonHeight,
        ]
    }
}
