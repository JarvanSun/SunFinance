//
//  OrdersPlaceholderView.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct OrdersPlaceholderView: View {
    let placeholder: OrdersPlaceholder
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

private extension OrdersPlaceholderView {
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
                title: .init("orders.failure.retry", bundle: .module),
                perform: onRetry
            )
        )
        .accessibilityIdentifier(OrdersAccessibility.retryButton)
    }
}

#if DEBUG
@available(iOS 26, *)
#Preview(
    "Placeholder",
    arguments: [OrdersPlaceholder.loading, .empty(.open), .empty(.past), .failed(.offline)]
) {
    OrdersPlaceholderView(placeholder: $0, onRetry: {})
}
#endif
