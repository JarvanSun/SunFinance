//
//  QuoteHeaderView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct QuoteHeaderView: View {
    @Environment(\.dimensions) private var dimensions

    let header: QuoteHeader

    var body: some View {
        VStack(alignment: .leading, spacing: dimensions.spaceMedium) {
            Text(verbatim: header.companyName)
                .textStyle(FinanceColor.textPrimary, FinanceFont.title)
                .lineLimit(2)

            HStack(alignment: .center, spacing: dimensions.spaceLargeSmall) {
                HeroAmount(header.price)

                VStack(alignment: .leading, spacing: dimensions.spaceXSmall) {
                    Text(header.moment.text)
                        .textStyle(FinanceColor.textSecondary, FinanceFont.caption)

                    QuoteChangeView(change: header.change)
                }
                .fixedSize()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 24) {
        QuoteHeaderView(
            header: PreviewObjectPool.header(change: 2.4, moment: .live(isMarketOpen: true))
        )

        QuoteHeaderView(
            header: PreviewObjectPool.header(change: -1.1, moment: .live(isMarketOpen: false))
        )

        QuoteHeaderView(header: PreviewObjectPool.header(change: 0, moment: .scrubbed(.now, .day)))

        QuoteHeaderView(header: PreviewObjectPool.pendingHeader)
    }
    .padding()
}
#endif
