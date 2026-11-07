//
//  DrawInRevealModifier.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

struct DrawInRevealModifier<Key: Hashable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var progress: CGFloat = 0

    let key: Key

    func body(content: Content) -> some View {
        content
            .mask(alignment: .leading) {
                Rectangle()
                    .scaleEffect(x: progress, y: 1, anchor: .leading)
            }
            .task(id: key) { await draw() }
    }

    private func draw() async {
        var reset = Transaction()
        reset.disablesAnimations = true
        withTransaction(reset) { progress = 0 }
        await Task.yield()
        withAnimation(FinanceMotion.draw.animation(reduceMotion: reduceMotion)) {
            progress = 1
        }
    }
}

extension View {
    func drawIn(key: some Hashable) -> some View {
        modifier(DrawInRevealModifier(key: key))
    }
}
