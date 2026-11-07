//
//  SlideToConfirm.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public struct SlideToConfirm: View {
    @Environment(\.dimensions) private var dimensions
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @GestureState private var dragOffset: CGFloat = 0
    @State private var hasPassedThreshold = false
    @State private var isCommitted = false

    private let title: LocalizedStringResource
    private let phase: SlideToConfirmPhase
    private let onConfirm: () -> Void

    public init(
        _ title: LocalizedStringResource,
        phase: SlideToConfirmPhase,
        onConfirm: @escaping () -> Void
    ) {
        self.title = title
        self.phase = phase
        self.onConfirm = onConfirm
    }

    public var body: some View {
        GeometryReader { proxy in
            let travel = max(proxy.size.width - knobSize - 2 * inset, 0)
            let offset = knobOffset(travel: travel)
            let progress = travel > 0 ? offset / travel : 0
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(FinanceColor.surface.color)

                Capsule()
                    .fill(FinanceColor.accentMuted.color)
                    .frame(width: offset + knobSize + 2 * inset)

                label
                    .opacity(phase == .ready ? 1 - min(progress * labelFadeSpeed, 1) : 0)
                    .frame(maxWidth: .infinity)
                    .padding(.leading, knobSize)

                knob
                    .offset(x: inset + offset)
                    .gesture(drag(travel: travel), isEnabled: phase == .ready && isEnabled)
            }
        }
        .frame(height: knobSize + 2 * inset)
        .opacity(isEnabled ? 1 : FinanceOpacity.dimmed.value)
        .animation(FinanceMotion.settle.animation(reduceMotion: reduceMotion), value: phase)
        .sensoryFeedback(.selection, trigger: hasPassedThreshold) { _, passed in passed }
        .sensoryFeedback(.success, trigger: phase) { _, phase in phase == .done }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(title))
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { confirm() }
        .onChange(of: phase) { _, phase in
            if phase == .ready {
                isCommitted = false
            }
        }
    }
}

// MARK: - Private

private extension SlideToConfirm {
    var knobSize: CGFloat { dimensions.slideKnobSize }

    var inset: CGFloat { dimensions.spaceXSmall }

    var threshold: CGFloat { 0.85 }

    var labelFadeSpeed: CGFloat { 1.6 }

    var labelMinimumScale: CGFloat { 0.8 }

    var knobShadowOpacity: Double { 0.12 }

    var knobShadowRadius: CGFloat { dimensions.slideKnobShadowRadius }

    var label: some View {
        Text(title)
            .textStyle(FinanceColor.textPrimary, FinanceFont.headline)
            .lineLimit(1)
            .minimumScaleFactor(labelMinimumScale)
            .shimmering(isActive: phase == .ready && isEnabled && !reduceMotion)
    }

    var knob: some View {
        ZStack {
            Circle()
                .fill(FinanceColor.accent.color)

            knobSymbol
                .id(phase)
                .transition(.identity)
                .font(FinanceFont.headline)
                .foregroundColor(FinanceColor.textOnAccent)
                .symbolEffect(.bounce, value: phase)
        }
        .frame(width: knobSize, height: knobSize)
        .shadow(
            color: FinanceColor.shadow.color.opacity(knobShadowOpacity),
            radius: knobShadowRadius,
            y: knobShadowRadius / 2
        )
        .contentShape(Circle())
    }

    @ViewBuilder
    var knobSymbol: some View {
        switch phase {
        case .ready:
            Image(style: FinanceImage.slideToConfirm)
        case .working:
            ProgressView()
                .tint(FinanceColor.textOnAccent.color)
        case .done:
            Image(style: FinanceImage.confirmed)
        }
    }

    func knobOffset(travel: CGFloat) -> CGFloat {
        switch phase {
        case .ready where isCommitted: travel
        case .ready: min(max(dragOffset, 0), travel)
        case .working, .done: travel
        }
    }

    func drag(travel: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragOffset) { value, offset, _ in
                offset = value.translation.width
            }
            .onChanged { value in
                hasPassedThreshold = travel > 0 && value.translation.width / travel >= threshold
            }
            .onEnded { value in
                let passed = travel > 0 && value.translation.width / travel >= threshold
                hasPassedThreshold = false
                guard passed else { return }

                isCommitted = true
                confirm()
            }
    }

    func confirm() {
        guard phase == .ready, isEnabled else { return }

        onConfirm()
    }
}

// MARK: - View

private extension View {
    func shimmering(isActive: Bool) -> some View {
        modifier(ShimmerModifier(isActive: isActive))
    }
}

private struct ShimmerModifier: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        switch isActive {
        case true:
            content
                .overlay { highlight }
                .compositingGroup()
        case false:
            content
        }
    }

    private var highlight: some View {
        GeometryReader { proxy in
            TimelineView(.animation) { timeline in
                let elapsed = timeline.date.timeIntervalSinceReferenceDate
                let phase =
                    elapsed.truncatingRemainder(dividingBy: period) / period
                LinearGradient(
                    stops: highlightStops,
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: proxy.size.width * highlightWidth)
                .offset(
                    x: CGFloat(phase) * proxy.size.width * (1 + highlightWidth) - proxy
                        .size.width * highlightWidth
                )
                .blendMode(.sourceAtop)
            }
        }
        .allowsHitTesting(false)
    }

    private var period: TimeInterval { FinanceMotion.shimmer.duration }

    private var highlightWidth: CGFloat { 0.5 }

    private var highlightOpacity: Double { 0.55 }

    private var highlightStops: [Gradient.Stop] {
        [
            .init(color: .clear, location: 0),
            .init(color: FinanceColor.highlight.color.opacity(highlightOpacity), location: 0.5),
            .init(color: .clear, location: 1),
        ]
    }
}

// MARK: - Previews

#if DEBUG
private struct SlideToConfirmPreview: View {
    @State private var phase = SlideToConfirmPhase.ready

    var body: some View {
        VStack(spacing: 24) {
            SlideToConfirm("Slide to buy", phase: phase) {
                phase = .working
                Task {
                    try? await Task.sleep(for: .seconds(1))
                    phase = .done
                }
            }

            SlideToConfirm("Slide to sell", phase: .ready) {}
                .disabled(true)

            Button(action: { phase = .ready }) {
                Text(verbatim: "Reset")
            }
            .buttonStyle(.finance(.secondary))
        }
        .padding()
    }
}

#Preview("Slide to Confirm") {
    SlideToConfirmPreview()
}
#endif
