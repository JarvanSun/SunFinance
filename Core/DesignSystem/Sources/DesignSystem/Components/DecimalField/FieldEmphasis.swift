//
//  FieldEmphasis.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import CoreGraphics
import SunUserInterface

enum FieldEmphasis: Equatable, Sendable {
    case resting
    case focused
    case invalid

    init(isFocused: Bool, isInvalid: Bool) {
        switch (isInvalid, isFocused) {
        case (true, _):
            self = .invalid
        case (false, true):
            self = .focused
        case (false, false):
            self = .resting
        }
    }

    var borderColor: FinanceColor {
        switch self {
        case .resting:
            .separator
        case .focused:
            .accent
        case .invalid:
            .critical
        }
    }

    func borderWidth(in dimensions: any DimensionStyling) -> CGFloat {
        switch self {
        case .resting:
            dimensions.borderWidthSmall
        case .focused, .invalid:
            dimensions.borderWidthMedium
        }
    }
}
