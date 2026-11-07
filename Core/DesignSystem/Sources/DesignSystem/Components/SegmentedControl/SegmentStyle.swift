//
//  SegmentStyle.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import CoreGraphics
import SunUserInterface
import SwiftUI

public enum SegmentStyle: CaseIterable, Hashable, Sendable {
    case prominent
    case quiet

    func foreground(isSelected: Bool) -> FinanceColor {
        switch (self, isSelected) {
        case (.prominent, true):
            .textOnAccent
        case (.quiet, true):
            .background
        case (.prominent, false):
            .textSecondary
        case (.quiet, false):
            .textPrimary
        }
    }

    func font(isSelected: Bool) -> FinanceFont {
        isSelected ? .headline : .callout
    }

    var capsuleColor: FinanceColor {
        switch self {
        case .prominent:
            .accent
        case .quiet:
            .textPrimary
        }
    }

    var trackColor: Color {
        switch self {
        case .prominent:
            FinanceColor.surfaceElevated.color
        case .quiet:
            .clear
        }
    }

    func trackPadding(in dimensions: any DimensionStyling) -> CGFloat {
        switch self {
        case .prominent:
            dimensions.spaceXSmall
        case .quiet:
            .zero
        }
    }

    func capsuleWidth(segmentWidth: CGFloat) -> CGFloat {
        switch self {
        case .prominent:
            segmentWidth
        case .quiet:
            segmentWidth * quietCapsuleWidthShare
        }
    }

    func capsuleHeight(in dimensions: any DimensionStyling) -> CGFloat? {
        switch self {
        case .prominent:
            nil
        case .quiet:
            dimensions.segmentCapsuleHeight
        }
    }
}

private extension SegmentStyle {
    var quietCapsuleWidthShare: CGFloat { 0.9 }
}
