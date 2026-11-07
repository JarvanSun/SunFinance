//
//  HandoffPhase.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import CoreGraphics
import SunUserInterface

enum HandoffPhase: Equatable, Sendable {
    case arriving
    case shown
    case leaving

    var opacity: Double {
        self == .shown ? 1 : 0
    }

    var scale: CGFloat {
        switch self {
        case .arriving:
            0.98
        case .shown:
            1
        case .leaving:
            1.04
        }
    }

    var isInteractive: Bool {
        self == .shown
    }

    func verticalOffset(in dimensions: any DimensionStyling) -> CGFloat {
        switch self {
        case .arriving:
            dimensions.handoffRiseDistance
        case .shown, .leaving:
            .zero
        }
    }
}
