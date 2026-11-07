//
//  SelectionDot.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

struct SelectionDot: View {
    @Environment(\.dimensions) private var dimensions

    let color: FinanceColor

    var body: some View {
        Circle()
            .fill(FinanceColor.surface.color)
            .overlay(
                Circle().stroke(color.color, lineWidth: dimensions.chartSelectionDotBorderWidth)
            )
            .frame(
                width: dimensions.chartSelectionDotSize,
                height: dimensions.chartSelectionDotSize
            )
            .shadow(
                color: color.color.opacity(shadowOpacity),
                radius: dimensions.chartSelectionShadowRadius
            )
            .accessibilityHidden(true)
    }
}

private extension SelectionDot {
    var shadowOpacity: Double { 0.3 }
}

#if DEBUG
#Preview {
    HStack(spacing: 32) {
        SelectionDot(color: .gain)

        SelectionDot(color: .loss)
    }
    .padding()
}
#endif
