//
//  WatchlistSectionHeader.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct WatchlistSectionHeader: View {
    let section: WatchlistSection

    var body: some View {
        switch section {
        case .quotes:
            EmptyView()
        case .quotesMatchingSearch:
            heading(LocalizedStringResource("watchlist.section.onWatchlist", bundle: .module))
        case .symbolMatches:
            heading(LocalizedStringResource("watchlist.section.symbolMatches", bundle: .module))
        }
    }
}

private extension WatchlistSectionHeader {
    func heading(_ title: LocalizedStringResource) -> some View {
        Text(title)
            .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
            .accessibilityAddTraits(.isHeader)
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack(alignment: .leading) {
        ForEach([WatchlistSection.quotes, .quotesMatchingSearch, .symbolMatches]) { section in
            WatchlistSectionHeader(section: section)
        }
    }
    .padding()
}
#endif
