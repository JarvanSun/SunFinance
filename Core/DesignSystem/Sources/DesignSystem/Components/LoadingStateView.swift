//
//  LoadingStateView.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public struct LoadingStateView: View {
    @Environment(\.dimensions) private var dimensions

    private let title: LocalizedStringResource

    public init(title: LocalizedStringResource) {
        self.title = title
    }

    public var body: some View {
        VStack(spacing: dimensions.spaceMedium) {
            ProgressView()

            Text(title)
                .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
        }
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
#Preview {
    LoadingStateView(title: "Loading quotes…")
}
#endif
