//
//  FloatingBottomBar.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

extension View {
    public func floatingBottomBar(@ViewBuilder _ content: () -> some View) -> some View {
        modifier(FloatingBottomBarModifier(bar: content()))
    }
}

private struct FloatingBottomBarModifier<Bar: View>: ViewModifier {
    let bar: Bar

    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content
                .safeAreaBar(edge: .bottom) { bar }
                .scrollEdgeEffectStyle(.soft, for: .bottom)
        } else {
            content.safeAreaInset(edge: .bottom) { bar }
        }
    }
}
