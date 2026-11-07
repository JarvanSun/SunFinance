//
//  QuoteDetailPlaceholderView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct QuoteDetailPlaceholderView: View {
    let placeholder: QuoteDetailPlaceholder
    let onRetry: () -> Void

    var body: some View {
        switch placeholder {
        case .loading:
            LoadingStateView(title: placeholder.title)
        case .failed(let issue):
            failure(issue)
        }
    }
}

private extension QuoteDetailPlaceholderView {
    func failure(_ issue: QuoteDetailIssue) -> some View {
        ContentUnavailableStateView(
            title: placeholder.title,
            message: issue.message,
            image: issue.image,
            action: StateAction(
                title: .init("quoteDetail.placeholder.retry", bundle: .module),
                accessibilityIdentifier: InstrumentAccessibility.quoteRetryButton,
                perform: onRetry
            )
        )
    }
}

#if DEBUG
@available(iOS 26, *)
#Preview(
    "Placeholder",
    arguments: [
        QuoteDetailPlaceholder.loading,
        .failed(.offline),
        .failed(.serviceUnavailable),
        .failed(.unreadableData),
    ]
) {
    QuoteDetailPlaceholderView(placeholder: $0, onRetry: {})
}
#endif
