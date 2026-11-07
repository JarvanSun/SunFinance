//
//  WatchlistPlaceholderView.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct WatchlistPlaceholderView: View {
    let placeholder: WatchlistPlaceholder
    let onRetry: () -> Void

    var body: some View {
        switch placeholder {
        case .loading, .searching:
            LoadingStateView(title: placeholder.title)
        case .unavailable(let reason):
            unavailable(reason)
        }
    }
}

private extension WatchlistPlaceholderView {
    func unavailable(_ reason: WatchlistUnavailableReason) -> some View {
        ContentUnavailableStateView(
            title: reason.title,
            message: reason.message,
            image: reason.image,
            action: reason.action(onRetry: onRetry)
        )
    }
}

#if DEBUG
@available(iOS 26, *)
#Preview(
    "Placeholder",
    arguments: [
        WatchlistPlaceholder.loading,
        .searching,
        .unavailable(.empty),
        .unavailable(.noSearchResults(query: "Tesla")),
        .unavailable(.failed(.offline)),
        .unavailable(.failed(.serviceUnavailable)),
        .unavailable(.failed(.unreadableData)),
    ]
) { placeholder in
    WatchlistPlaceholderView(placeholder: placeholder, onRetry: {})
}
#endif
