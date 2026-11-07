//
//  FinanceColor.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public enum FinanceColor: String, CaseIterable, ColorStyling, Sendable {
    case textPrimary
    case textSecondary
    case textOnAccent
    case background
    case surface
    case surfaceElevated
    case separator
    case accent
    case accentMuted
    case gain
    case loss
    case unchanged
    case warning
    case critical
    case shadow
    case highlight

    public var color: Color {
        Color(rawValue, bundle: .module)
    }
}

#if DEBUG
#Preview("Colors") {
    ScrollView {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(FinanceColor.allCases, id: \.self) { color in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color.color)
                        .stroke(FinanceColor.separator.color, lineWidth: 0.5)
                        .frame(width: 44, height: 44)

                    Text(verbatim: color.rawValue)
                        .textStyle(FinanceColor.textPrimary, FinanceFont.body)
                }
            }
        }
        .padding()
    }
    .background(FinanceColor.background.color)
}
#endif
