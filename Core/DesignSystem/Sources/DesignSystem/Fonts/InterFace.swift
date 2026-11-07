//
//  InterFace.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

nonisolated enum InterFace: String, CaseIterable, Sendable {
    case regular = "Inter-Regular"
    case medium = "Inter-Medium"
    case semiBold = "Inter-SemiBold"
    case bold = "Inter-Bold"

    var postScriptName: String { rawValue }

    var weight: Font.Weight {
        switch self {
        case .regular:
            .regular
        case .medium:
            .medium
        case .semiBold:
            .semibold
        case .bold:
            .bold
        }
    }
}
