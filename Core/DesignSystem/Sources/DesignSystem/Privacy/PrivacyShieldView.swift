//
//  PrivacyShieldView.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

struct PrivacyShieldView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.regularMaterial)

            Image(style: FinanceImage.appMark)
                .font(FinanceFont.largeTitle)
                .imageScale(.large)
                .foregroundColor(FinanceColor.accent)
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

extension View {
    public func privacyShield(isShielded: Bool) -> some View {
        modifier(PrivacyShieldModifier(isShielded: isShielded))
    }
}

private struct PrivacyShieldModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let isShielded: Bool

    func body(content: Content) -> some View {
        content.overlay {
            PrivacyShieldView()
                .opacity(isShielded ? 1 : 0)
                .allowsHitTesting(isShielded)
                .animation(
                    FinanceMotion.snappy.animation(reduceMotion: reduceMotion),
                    value: isShielded
                )
        }
    }
}

#if DEBUG
#Preview("Privacy Shield") {
    VStack(spacing: 12) {
        Text(verbatim: "€22,240.12")
            .font(FinanceFont.priceLarge)

        Text(verbatim: "SAP · 15 shares")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .privacyShield(isShielded: true)
}
#endif
