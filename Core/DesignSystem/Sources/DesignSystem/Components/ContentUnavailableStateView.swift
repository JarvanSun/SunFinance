//
//  ContentUnavailableStateView.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public struct ContentUnavailableStateView: View {
    @Environment(\.dimensions) private var dimensions

    private let title: LocalizedStringResource
    private let message: LocalizedStringResource
    private let image: FinanceImage
    private let action: StateAction?

    public init(
        title: LocalizedStringResource,
        message: LocalizedStringResource,
        image: FinanceImage,
        action: StateAction? = nil
    ) {
        self.title = title
        self.message = message
        self.image = image
        self.action = action
    }

    public var body: some View {
        VStack(spacing: dimensions.spaceMedium) {
            Image(style: image)
                .font(FinanceFont.largeTitle)
                .foregroundColor(FinanceColor.textSecondary)
                .accessibilityHidden(true)

            Text(title)
                .textStyle(FinanceColor.textPrimary, FinanceFont.title)

            Text(message)
                .textStyle(FinanceColor.textSecondary, FinanceFont.body)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: dimensions.placeholderMaximumWidth)
        .accessibilityElement(children: .combine)
        .safeAreaInset(edge: .bottom, if: action) { action in
            Button(action: action.perform) {
                Text(action.title)
            }
            .buttonStyle(.finance(.primary))
            .accessibilityIdentifier(action.accessibilityIdentifier)
            .padding(.top, dimensions.spaceLargeSmall)
        }
        .padding(dimensions.spaceXLarge)
    }
}

#if DEBUG
#Preview {
    ScrollView {
        VStack {
            ContentUnavailableStateView(
                title: "You're offline",
                message: "Check your connection and try again.",
                image: .offline,
                action: StateAction(title: "Try again", perform: {})
            )

            ContentUnavailableStateView(
                title: "No quotes yet",
                message: "Add a symbol to start your watchlist.",
                image: .emptyWatchlist
            )
        }
    }
}
#endif
