//
//  CompletionBadge.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public struct CompletionBadge: View {
    @Environment(\.dimensions) private var dimensions
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isDrawn = false

    private let image: FinanceImage
    private let color: FinanceColor
    private let feedback: SensoryFeedback?

    public init(image: FinanceImage, color: FinanceColor, feedback: SensoryFeedback? = nil) {
        self.image = image
        self.color = color
        self.feedback = feedback
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(color.color.opacity(fillOpacity))
                .scaleEffect(isShown ? 1 : startScale)

            Circle()
                .trim(from: 0, to: isShown ? 1 : 0)
                .stroke(color.color, style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(FinanceMotion.draw.animation(reduceMotion: reduceMotion), value: isShown)

            Image(style: image)
                .font(FinanceFont.largeTitle)
                .imageScale(.large)
                .foregroundColor(color)
                .scaleEffect(isShown ? 1 : 0)
                .opacity(isShown ? 1 : 0)
                .animation(
                    FinanceMotion.emphasis.animation(reduceMotion: reduceMotion)?.delay(
                        FinanceMotion.draw.duration * symbolDelayShare
                    ),
                    value: isShown
                )
        }
        .frame(width: badgeSize, height: badgeSize)
        .animation(FinanceMotion.settle.animation(reduceMotion: reduceMotion), value: isShown)
        .sensoryFeedback(trigger: isShown) { _, isShown in isShown ? feedback : nil }
        .onAppear { isDrawn = true }
        .accessibilityHidden(true)
    }
}

private extension CompletionBadge {
    var isShown: Bool { isDrawn || reduceMotion }

    var badgeSize: CGFloat { dimensions.completionBadgeSize }

    var ringWidth: CGFloat { dimensions.completionBadgeRingWidth }

    var fillOpacity: Double { 0.14 }

    var startScale: CGFloat { 0.6 }

    var symbolDelayShare: Double { 0.55 }
}

#if DEBUG
private struct CompletionBadgePreview: View {
    @State private var replay = 0

    var body: some View {
        VStack(spacing: 32) {
            HStack(spacing: 24) {
                CompletionBadge(image: .success, color: .gain, feedback: .success)

                CompletionBadge(image: .scheduled, color: .accent)

                CompletionBadge(image: .rejected, color: .critical, feedback: .error)
            }
            .id(replay)

            Button(action: { replay += 1 }) {
                Text(verbatim: "Replay")
            }
            .buttonStyle(.finance(.secondary))
        }
        .padding()
    }
}

#Preview("Completion Badge") {
    CompletionBadgePreview()
}
#endif
