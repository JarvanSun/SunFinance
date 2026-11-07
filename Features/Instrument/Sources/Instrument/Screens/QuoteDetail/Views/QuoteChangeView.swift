//
//  QuoteChangeView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct QuoteChangeView: View {
    @Environment(\.dimensions) private var dimensions

    let change: QuoteChange

    var body: some View {
        switch change {
        case .pending:
            Text(verbatim: reservedLine)
                .font(FinanceFont.callout)
                .accessibilityHidden(true)
        case .known(let change):
            HStack(spacing: dimensions.spaceSmall) {
                Text(verbatim: change.percentText)

                Rectangle()
                    .fill(FinanceColor.separator.color)
                    .frame(width: dimensions.borderWidthSmall, height: dimensions.spaceMedium)

                Text(verbatim: change.amountText)
            }
            .textStyle(change.trend.color, FinanceFont.callout)
            .monospacedDigit()
        }
    }
}

private extension QuoteChangeView {
    var reservedLine: String { "\u{00A0}" }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack(alignment: .leading) {
        QuoteChangeView(change: PreviewObjectPool().change(2.4))

        QuoteChangeView(change: PreviewObjectPool().change(-1.1))

        QuoteChangeView(change: .pending)
            .border(.secondary)
    }
    .padding()
}
#endif
