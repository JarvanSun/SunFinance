//
//  ClosedPositionRowView.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct ClosedPositionRowView: View {
    @Environment(\.dimensions) private var dimensions

    let position: Position

    var body: some View {
        HStack(spacing: dimensions.spaceMedium) {
            VStack(alignment: .leading, spacing: dimensions.spaceXSmall) {
                Text(verbatim: position.symbol.rawValue)
                    .textStyle(FinanceColor.textPrimary, FinanceFont.headline)

                Text("portfolio.closed.realizedLabel", bundle: .module)
                    .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
            }

            Spacer(minLength: dimensions.spaceSmall)

            Text(verbatim: position.realizedText)
                .textStyle(position.realizedTrend.color, FinanceFont.headline)
                .monospacedDigit()
        }
        .padding(.horizontal, dimensions.spaceSmall)
        .padding(.vertical, dimensions.spaceMedium)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(position.closedAccessibilityLabel))
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 0) {
        ClosedPositionRowView(
            position: .dummy("KO", quantity: 0, value: 0, gain: 96.3)
        )

        ClosedPositionRowView(
            position: .dummy("TSLA", quantity: 0, value: 0, gain: -42)
        )
    }
    .padding()
}
#endif
