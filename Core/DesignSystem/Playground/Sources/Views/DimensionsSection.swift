//
//  DimensionsSection.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct DimensionsSection: View {
    @Environment(\.dimensions) private var dimensions

    var body: some View {
        Section {
            ForEach(tokens, id: \.name) { token in
                HStack(spacing: dimensions.spaceMedium) {
                    Text(verbatim: token.name)
                        .textStyle(FinanceColor.textPrimary, FinanceFont.callout)

                    Spacer()

                    Text(token.value, format: .number)
                        .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
                        .monospacedDigit()
                }
            }
        } header: {
            Text(verbatim: "Dimensions")
        }
    }
}

private extension DimensionsSection {
    var tokens: [(name: String, value: CGFloat)] {
        [
            ("spaceXSmall", dimensions.spaceXSmall),
            ("spaceSmall", dimensions.spaceSmall),
            ("spaceXMedium", dimensions.spaceXMedium),
            ("spaceMedium", dimensions.spaceMedium),
            ("spaceLargeSmall", dimensions.spaceLargeSmall),
            ("spaceLargeExtra", dimensions.spaceLargeExtra),
            ("spaceXLarge", dimensions.spaceXLarge),
            ("spaceXXLarge", dimensions.spaceXXLarge),
            ("spaceXXLargeExtra", dimensions.spaceXXLargeExtra),
            ("spaceXXLargeExtra42", dimensions.spaceXXLargeExtra42),
            ("spaceXXXLarge", dimensions.spaceXXXLarge),
            ("spaceXXXXLarge", dimensions.spaceXXXXLarge),
            ("cornerRadiusSmall", dimensions.cornerRadiusSmall),
            ("cornerRadiusMedium", dimensions.cornerRadiusMedium),
            ("cornerRadiusLarge", dimensions.cornerRadiusLarge),
            ("inProgressViewLarge", dimensions.inProgressViewLarge),
            ("inProgressViewSmall", dimensions.inProgressViewSmall),
            ("borderWidthMedium", dimensions.borderWidthMedium),
            ("borderWidthSmall", dimensions.borderWidthSmall),
            ("borderWidthXSmall", dimensions.borderWidthXSmall),
            ("minimumTapTarget", dimensions.minimumTapTarget),
            ("placeholderMaximumWidth", dimensions.placeholderMaximumWidth),
            ("placeholderMinimumHeight", dimensions.placeholderMinimumHeight),
            ("headerPlaceholderHeight", dimensions.headerPlaceholderHeight),
            ("formMaximumWidth", dimensions.formMaximumWidth),
            ("heroAmountSpacing", dimensions.heroAmountSpacing),
            ("heroAmountRowSpacing", dimensions.heroAmountRowSpacing),
            ("heroAmountKerning", dimensions.heroAmountKerning),
            ("chartHeight", dimensions.chartHeight),
            ("volumeChartHeight", dimensions.volumeChartHeight),
            ("chartLineWidth", dimensions.chartLineWidth),
            ("chartMarkerSize", dimensions.chartMarkerSize),
            ("chartDashLength", dimensions.chartDashLength),
            ("chartSliceGap", dimensions.chartSliceGap),
            ("chartLiveDotSize", dimensions.chartLiveDotSize),
            ("chartLiveEndPadding", dimensions.chartLiveEndPadding),
            ("chartSelectionDotSize", dimensions.chartSelectionDotSize),
            ("chartSelectionDotBorderWidth", dimensions.chartSelectionDotBorderWidth),
            ("chartSelectionShadowRadius", dimensions.chartSelectionShadowRadius),
            ("chartScrubMaskWidth", dimensions.chartScrubMaskWidth),
            ("segmentCapsuleHeight", dimensions.segmentCapsuleHeight),
            ("slideKnobSize", dimensions.slideKnobSize),
            ("slideKnobShadowRadius", dimensions.slideKnobShadowRadius),
            ("completionBadgeSize", dimensions.completionBadgeSize),
            ("completionBadgeRingWidth", dimensions.completionBadgeRingWidth),
            ("handoffRiseDistance", dimensions.handoffRiseDistance),
            ("shakeDistance", dimensions.shakeDistance),
            ("cornerRadiusSurface", dimensions.cornerRadiusSurface),
            ("swatchHeight", dimensions.swatchHeight),
            ("actionButtonHeight", dimensions.actionButtonHeight),
        ]
    }
}

#if DEBUG
#Preview {
    List {
        DimensionsSection()
    }
}
#endif
