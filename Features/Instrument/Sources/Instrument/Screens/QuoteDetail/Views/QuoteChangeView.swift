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
            pending
        case .known(let change):
            known(change)
        }
    }
}

private extension QuoteChangeView {
    var reservedLine: String { "\u{00A0}" }

    var pending: some View {
        Text(verbatim: reservedLine)
            .font(FinanceFont.callout)
            .accessibilityHidden(true)
    }

    func known(_ change: PriceChange) -> some View {
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

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack(alignment: .leading) {
        QuoteChangeView(change: .dummy(2.4))

        QuoteChangeView(change: .dummy(-1.1))

        QuoteChangeView(change: .pending)
            .border(.secondary)
    }
    .padding()
}
#endif
