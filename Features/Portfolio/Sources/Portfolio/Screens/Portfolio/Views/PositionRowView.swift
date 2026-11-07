//
//  PositionRowView.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct PositionRowView: View {
    @Environment(\.dimensions) private var dimensions

    let position: Position
    let swatch: Color
    let highlight: Color

    var body: some View {
        HStack(spacing: dimensions.spaceMedium) {
            RoundedRectangle(cornerRadius: dimensions.borderWidthMedium, style: .continuous)
                .fill(swatch)
                .frame(width: dimensions.borderWidthMedium * 2, height: dimensions.swatchHeight)

            VStack(alignment: .leading, spacing: dimensions.spaceXSmall) {
                Text(verbatim: position.symbol.rawValue)
                    .textStyle(FinanceColor.textPrimary, FinanceFont.headline)

                Text(verbatim: position.valueText)
                    .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
                    .monospacedDigit()
            }

            Spacer(minLength: dimensions.spaceSmall)

            VStack(alignment: .trailing, spacing: dimensions.spaceXSmall) {
                HeroAmount(position.price, size: .row)

                Text(verbatim: position.returnText)
                    .textStyle(position.trend.color, FinanceFont.callout)
                    .monospacedDigit()
            }
        }
        .padding(.vertical, dimensions.spaceMedium)
        .padding(.horizontal, dimensions.spaceSmall)
        .background(
            RoundedRectangle(cornerRadius: dimensions.cornerRadiusLarge, style: .continuous)
                .fill(highlight)
        )
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(position.accessibilityLabel))
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 0) {
        PositionRowView(
            position: PreviewObjectPool().position("SAP", quantity: 15, value: 3_425, gain: 412.5),
            swatch: FinanceColor.accent.color,
            highlight: .clear
        )

        PositionRowView(
            position: PreviewObjectPool().position(
                "NVDA",
                quantity: 15,
                value: 2_610,
                gain: -188.4
            ),
            swatch: FinanceColor.accentMuted.color,
            highlight: FinanceColor.accentMuted.color.opacity(0.12)
        )
    }
    .padding()
}
#endif
