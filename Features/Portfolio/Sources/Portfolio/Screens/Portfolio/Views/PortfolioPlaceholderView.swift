//
//  PortfolioPlaceholderView.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct PortfolioPlaceholderView: View {
    let placeholder: PortfolioPlaceholder
    let onRetry: () -> Void

    var body: some View {
        switch placeholder {
        case .loading:
            LoadingStateView(title: placeholder.title)
        case .empty:
            empty
        case .failed:
            failure
        }
    }
}

private extension PortfolioPlaceholderView {
    var empty: some View {
        ContentUnavailableStateView(
            title: placeholder.title,
            message: placeholder.message,
            image: placeholder.image
        )
    }

    var failure: some View {
        ContentUnavailableStateView(
            title: placeholder.title,
            message: placeholder.message,
            image: placeholder.image,
            action: StateAction(
                title: .init("portfolio.failure.retry", bundle: .module),
                perform: onRetry
            )
        )
        .accessibilityIdentifier(PortfolioAccessibility.retryButton)
    }
}

#if DEBUG
@available(iOS 26, *)
#Preview(
    "Placeholder",
    arguments: [
        PortfolioPlaceholder.loading, .empty, .failed(.offline), .failed(.serviceUnavailable),
    ]
) {
    PortfolioPlaceholderView(placeholder: $0, onRetry: {})
}
#endif
