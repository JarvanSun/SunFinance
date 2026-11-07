//
//  FavoriteSwipeButton.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct FavoriteSwipeButton: View {
    let action: FavoriteAction
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            Label {
                Text(action.title)
            } icon: {
                Image(style: action.swipeImage)
            }
        }
        .tint(FinanceColor.accent.color)
    }
}

#if DEBUG
#Preview {
    List {
        QuoteRowView(quote: .dummyGaining, favoriteAction: .add)
            .swipeActions { FavoriteSwipeButton(action: .add, onToggle: {}) }

        QuoteRowView(quote: .dummyLosing, favoriteAction: .remove)
            .swipeActions { FavoriteSwipeButton(action: .remove, onToggle: {}) }
    }
    .listStyle(.plain)
}
#endif
