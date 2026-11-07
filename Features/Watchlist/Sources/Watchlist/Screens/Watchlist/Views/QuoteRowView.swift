//
//  QuoteRowView.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct QuoteRowView: View {
    @Environment(\.dimensions) private var dimensions

    let quote: StockQuote
    let favoriteAction: FavoriteAction

    var body: some View {
        HStack(spacing: dimensions.spaceMedium) {
            VStack(alignment: .leading, spacing: dimensions.spaceXSmall) {
                Text(verbatim: quote.companyName)
                    .textStyle(FinanceColor.textPrimary, FinanceFont.headline)
                    .lineLimit(2)

                Text(verbatim: quote.symbol.rawValue)
                    .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
                    .overlay(if: favoriteAction.rowBadge, alignment: .trailing) { badge in
                        Image(style: badge)
                            .textStyle(FinanceColor.warning, FinanceFont.caption)
                            .padding(.leading, dimensions.spaceXSmall)
                            .alignmentGuide(.trailing) { $0[.leading] }
                            .accessibilityHidden(true)
                    }
            }
            .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }

            Spacer(minLength: dimensions.spaceSmall)

            VStack(alignment: .trailing, spacing: dimensions.spaceXSmall) {
                HeroAmount(quote.price, size: .row)

                Text(verbatim: quote.formattedChange)
                    .textStyle(quote.trend.color, FinanceFont.callout)
                    .monospacedDigit()
            }
            .fixedSize()
        }
        .padding(.vertical, dimensions.spaceSmall)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(quote.accessibilityLabel))
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack(alignment: .leading) {
        QuoteRowView(quote: PreviewObjectPool.gainingQuote, favoriteAction: .remove)

        QuoteRowView(quote: PreviewObjectPool.losingQuote, favoriteAction: .add)

        QuoteRowView(quote: PreviewObjectPool.unchangedQuote, favoriteAction: .add)

        QuoteRowView(quote: PreviewObjectPool.losingQuote, favoriteAction: .remove)
            .environment(\.locale, Locale(identifier: "de_DE"))
    }
    .padding()
}
#endif
