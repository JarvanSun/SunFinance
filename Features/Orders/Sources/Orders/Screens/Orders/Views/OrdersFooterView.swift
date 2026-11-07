//
//  OrdersFooterView.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct OrdersFooterView: View {
    @Environment(\.dimensions) private var dimensions

    let footer: OrdersFooter
    let onRetry: () -> Void

    var body: some View {
        switch footer {
        case .loadingMore:
            ProgressView()
                .frame(maxWidth: .infinity)
                .accessibilityLabel(Text("orders.footer.loading", bundle: .module))
        case .failed(let issue):
            VStack(spacing: dimensions.spaceSmall) {
                Text(issue.title)
                    .textStyle(FinanceColor.textSecondary, FinanceFont.callout)

                Button(action: onRetry) {
                    Text("orders.footer.retry", bundle: .module)
                }
                .buttonStyle(.finance(.tertiary))
                .accessibilityIdentifier(OrdersAccessibility.pageRetryButton)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 32) {
        OrdersFooterView(footer: .loadingMore, onRetry: {})

        OrdersFooterView(footer: .failed(.offline), onRetry: {})
    }
    .padding()
}
#endif
