//
//  WatchlistDestinationView.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct WatchlistDestinationView: FeatureDestinationView {
    let destination: WatchlistDestination
    let quoteDetail: FeatureEntry<TickerSymbol>

    var body: some View {
        switch destination {
        case .root:
            EmptyView()
        case .quoteDetail(let symbol):
            quoteDetail.view(for: symbol)
        }
    }
}
