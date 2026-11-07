//
//  WatchlistToolbar.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct WatchlistToolbar: ToolbarContent {
    let sortOrder: WatchlistSortOrder
    let onSelect: (WatchlistSortOrder) -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker(selection: selection) {
                    ForEach(WatchlistSortOrder.allCases) { order in
                        Text(order.title).tag(order)
                    }
                } label: {
                    Text("watchlist.sort.menu", bundle: .module)
                }
            } label: {
                Label {
                    Text("watchlist.sort.menu", bundle: .module)
                } icon: {
                    Image(style: FinanceImage.sort)
                }
            }
            .accessibilityIdentifier(WatchlistAccessibility.sortMenu)
        }
    }

    private var selection: Binding<WatchlistSortOrder> {
        Binding(get: { sortOrder }, set: { onSelect($0) })
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        Color.clear
            .toolbar { WatchlistToolbar(sortOrder: .marketCap, onSelect: { _ in }) }
    }
}
#endif
