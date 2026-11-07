//
//  SymbolMatchRowView.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct SymbolMatchRowView: View {
    @Environment(\.dimensions) private var dimensions

    let match: SymbolMatch
    let addition: SymbolAddition

    var body: some View {
        HStack(spacing: dimensions.spaceMedium) {
            VStack(alignment: .leading, spacing: dimensions.spaceXSmall) {
                Text(verbatim: match.companyName)
                    .textStyle(FinanceColor.textPrimary, FinanceFont.headline)
                    .lineLimit(2)

                Text(match.listing)
                    .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
            }
            .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }

            Spacer(minLength: dimensions.spaceSmall)

            Image(style: addition.image)
                .textStyle(addition.imageColor, FinanceFont.title)
                .frame(
                    minWidth: dimensions.minimumTapTarget,
                    minHeight: dimensions.minimumTapTarget
                )
        }
        .padding(.vertical, dimensions.spaceXSmall)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(match.accessibilityLabel))
        .accessibilityHint(Text(addition.accessibilityHint))
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack(alignment: .leading) {
        SymbolMatchRowView(match: .dummyTesla, addition: .available)

        SymbolMatchRowView(match: .dummySiemens, addition: .added)

        SymbolMatchRowView(match: .dummySiemens, addition: .available)
            .environment(\.locale, Locale(identifier: "de_DE"))
    }
    .padding()
}
#endif
