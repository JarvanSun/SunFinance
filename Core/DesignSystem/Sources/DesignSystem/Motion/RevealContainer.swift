//
//  RevealContainer.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

public struct RevealContainer<Content: View>: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let isRevealed: Bool
    private let content: Content

    public init(isRevealed: Bool, @ViewBuilder content: () -> Content) {
        self.isRevealed = isRevealed
        self.content = content()
    }

    public var body: some View {
        RevealLayout(progress: isRevealed ? 1 : 0) {
            content
                .transaction { $0.animation = nil }
        }
        .clipped()
        .animation(FinanceMotion.reveal.animation(reduceMotion: reduceMotion), value: isRevealed)
        .allowsHitTesting(isRevealed)
        .accessibilityHidden(!isRevealed)
    }
}

private struct RevealLayout: Layout {
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let size = contentSize(proposal: proposal, subviews: subviews)
        return CGSize(width: size.width, height: size.height * progress)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let width = ProposedViewSize(width: bounds.width, height: nil)
        for subview in subviews {
            subview.place(at: bounds.origin, anchor: .topLeading, proposal: width)
        }
    }

    private func contentSize(proposal: ProposedViewSize, subviews: Subviews) -> CGSize {
        let width = ProposedViewSize(width: proposal.width, height: nil)
        let sizes = subviews.map { $0.sizeThatFits(width) }
        return CGSize(
            width: sizes.map(\.width).max() ?? 0,
            height: sizes.map(\.height).max() ?? 0
        )
    }
}

#if DEBUG
private struct RevealContainerPreview: View {
    @State private var isRevealed = false

    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $isRevealed) { Text(verbatim: "Reveal") }

            RevealContainer(isRevealed: isRevealed) {
                Text(verbatim: "Limit price, trigger and validity live here, revealed in place.")
                    .padding()
                    .background(FinanceColor.surfaceElevated.color)
            }

            Text(verbatim: "The row below never overlaps.")
        }
        .padding()
    }
}

#Preview {
    RevealContainerPreview()
}
#endif
