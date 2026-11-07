//
//  TicketPlaceholderView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct TicketPlaceholderView: View {
    let placeholder: TicketPlaceholder
    let onRetry: () -> Void

    var body: some View {
        switch placeholder {
        case .loading:
            LoadingStateView(title: TradingText.loading)
        case .failed(let issue):
            ContentUnavailableStateView(
                title: issue.title,
                message: issue.message,
                image: issue.image,
                action: StateAction(title: TradingText.retry, perform: onRetry)
            )
            .accessibilityIdentifier(InstrumentAccessibility.ticketRetryButton)
        }
    }
}

#if DEBUG
@available(iOS 26, *)
#Preview(
    "Placeholder",
    arguments: [
        TicketPlaceholder.loading, .failed(.offline), .failed(.serviceUnavailable),
    ]
) {
    TicketPlaceholderView(placeholder: $0, onRetry: {})
}
#endif
