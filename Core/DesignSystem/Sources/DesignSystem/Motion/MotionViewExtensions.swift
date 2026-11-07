//
//  MotionViewExtensions.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

extension View {
    public func financeAnimation(_ motion: FinanceMotion, value: some Equatable) -> some View {
        modifier(FinanceAnimationModifier(motion: motion, value: value))
    }

    public func financeShake(count: Int) -> some View {
        modifier(FinanceShakeModifier(count: count))
    }

    public func financeNumberRoll(value: Double) -> some View {
        modifier(FinanceNumberRollModifier(value: value))
    }
}

private struct FinanceAnimationModifier<Value: Equatable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let motion: FinanceMotion
    let value: Value

    func body(content: Content) -> some View {
        content.animation(motion.animation(reduceMotion: reduceMotion), value: value)
    }
}

private struct FinanceShakeModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dimensions) private var dimensions

    let count: Int

    func body(content: Content) -> some View {
        let distance = reduceMotion ? .zero : dimensions.shakeDistance
        return
            content
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: count) { view, swing in
                view.offset(x: swing * distance)
            } keyframes: { _ in
                KeyframeTrack {
                    for swing in swings {
                        CubicKeyframe(swing, duration: FinanceMotion.shake.duration)
                    }
                }
            }
            .sensoryFeedback(.warning, trigger: count)
    }

    private var swings: [CGFloat] { [-1, 0.9, -0.7, 0.5, -0.2, 0] }
}

private struct FinanceNumberRollModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let value: Double

    func body(content: Content) -> some View {
        content
            .contentTransition(reduceMotion ? .identity : .numericText(value: value))
            .financeAnimation(.settle, value: value)
    }
}

#if DEBUG
private struct MotionViewExtensionsPreview: View {
    @State private var shakes = 0
    @State private var amount = 231.42

    var body: some View {
        VStack(spacing: 24) {
            Text(verbatim: "Invalid quantity")
                .textStyle(FinanceColor.critical, FinanceFont.headline)
                .financeShake(count: shakes)

            Button(action: { shakes += 1 }) {
                Text(verbatim: "Shake")
            }
            .buttonStyle(.finance(.secondary))

            Text(amount, format: .currency(code: "USD"))
                .textStyle(FinanceColor.textPrimary, FinanceFont.priceLarge)
                .monospacedDigit()
                .financeNumberRoll(value: amount)

            Button(action: { amount += Double.random(in: -20...20) }) {
                Text(verbatim: "Roll")
            }
            .buttonStyle(.finance(.secondary))
        }
        .padding()
    }
}

#Preview("Shake and number roll") {
    MotionViewExtensionsPreview()
}
#endif
