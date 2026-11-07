//
//  DimensionStylingExtensions.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import CoreGraphics
import SunUserInterface

extension DimensionStyling {
    public var minimumTapTarget: CGFloat {
        value(for: .minimumTapTarget, default: 44)
    }

    public var placeholderMaximumWidth: CGFloat {
        value(for: .placeholderMaximumWidth, default: 320)
    }

    public var placeholderMinimumHeight: CGFloat {
        value(for: .placeholderMinimumHeight, default: 240)
    }

    public var headerPlaceholderHeight: CGFloat {
        value(for: .headerPlaceholderHeight, default: 64)
    }

    public var formMaximumWidth: CGFloat {
        value(for: .formMaximumWidth, default: 460)
    }

    public var heroAmountSpacing: CGFloat {
        value(for: .heroAmountSpacing, default: 2)
    }

    public var heroAmountRowSpacing: CGFloat {
        value(for: .heroAmountRowSpacing, default: 1)
    }

    public var heroAmountKerning: CGFloat {
        value(for: .heroAmountKerning, default: -1)
    }

    public var chartHeight: CGFloat {
        value(for: .chartHeight, default: 240)
    }

    public var volumeChartHeight: CGFloat {
        value(for: .volumeChartHeight, default: 44)
    }

    public var chartLineWidth: CGFloat {
        value(for: .chartLineWidth, default: 2)
    }

    public var chartMarkerSize: CGFloat {
        value(for: .chartMarkerSize, default: 80)
    }

    public var chartDashLength: CGFloat {
        value(for: .chartDashLength, default: 4)
    }

    var chartDash: [CGFloat] {
        [chartDashLength, chartDashLength]
    }

    public var chartSliceGap: CGFloat {
        value(for: .chartSliceGap, default: 1.5)
    }

    public var chartLiveDotSize: CGFloat {
        value(for: .chartLiveDotSize, default: 10)
    }

    public var chartLiveEndPadding: CGFloat {
        value(for: .chartLiveEndPadding, default: 16)
    }

    public var chartSelectionDotSize: CGFloat {
        value(for: .chartSelectionDotSize, default: 12)
    }

    public var chartSelectionDotBorderWidth: CGFloat {
        value(for: .chartSelectionDotBorderWidth, default: 3)
    }

    public var chartSelectionShadowRadius: CGFloat {
        value(for: .chartSelectionShadowRadius, default: 4)
    }

    public var chartScrubMaskWidth: CGFloat {
        value(for: .chartScrubMaskWidth, default: 4)
    }

    public var segmentCapsuleHeight: CGFloat {
        value(for: .segmentCapsuleHeight, default: 32)
    }

    public var slideKnobSize: CGFloat {
        value(for: .slideKnobSize, default: 56)
    }

    public var slideKnobShadowRadius: CGFloat {
        value(for: .slideKnobShadowRadius, default: 4)
    }

    public var completionBadgeSize: CGFloat {
        value(for: .completionBadgeSize, default: 96)
    }

    public var completionBadgeRingWidth: CGFloat {
        value(for: .completionBadgeRingWidth, default: 4)
    }

    public var handoffRiseDistance: CGFloat {
        value(for: .handoffRiseDistance, default: 24)
    }

    public var shakeDistance: CGFloat {
        value(for: .shakeDistance, default: 10)
    }

    public var cornerRadiusSurface: CGFloat {
        value(for: .cornerRadiusSurface, default: 22)
    }

    public var swatchHeight: CGFloat {
        value(for: .swatchHeight, default: 40)
    }

    public var actionButtonHeight: CGFloat {
        value(for: .actionButtonHeight, default: 56)
    }
}
