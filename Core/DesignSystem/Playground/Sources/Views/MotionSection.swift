//
//  MotionSection.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct MotionSection: View {
    @Environment(\.dimensions) private var dimensions
    @State private var isRevealed = false
    @State private var isHandedOver = false
    @State private var shakes = 0
    @State private var amount = 231.42
    @State private var phase = SlideToConfirmPhase.ready
    @State private var badgeReplay = 0

    var body: some View {
        Section {
            Toggle(isOn: $isRevealed) {
                Text(verbatim: "RevealContainer")
            }
            .tint(FinanceColor.accent.color)

            RevealContainer(isRevealed: isRevealed) {
                Text(verbatim: "Options revealed in place.")
                    .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
            }

            HandoffContainer(value: isHandedOver) { isHandedOver in
                Button(action: { self.isHandedOver.toggle() }) {
                    Text(verbatim: isHandedOver ? "Result" : "Review")
                }
                .buttonStyle(.finance(.secondary))
            }
            .frame(height: dimensions.headerPlaceholderHeight)

            Button(action: { shakes += 1 }) {
                Text(verbatim: "financeShake")
            }
            .buttonStyle(.finance(.tertiary))
            .financeShake(count: shakes)

            Button(action: { amount += Double.random(in: -20...20) }) {
                Text(amount, format: .currency(code: "USD"))
                    .monospacedDigit()
                    .financeNumberRoll(value: amount)
            }
            .buttonStyle(.finance(.row))

            SlideToConfirm("Slide to buy", phase: phase) {
                phase = .done
            }

            Button(action: { phase = .ready }) {
                Text(verbatim: "Reset slider")
            }
            .buttonStyle(.finance(.tertiary))

            HStack {
                CompletionBadge(image: .success, color: .gain, feedback: .success)

                CompletionBadge(image: .rejected, color: .critical)
            }
            .id(badgeReplay)
            .onTapGesture { badgeReplay += 1 }
        } header: {
            Text(verbatim: "Motion")
        }
    }
}

#if DEBUG
#Preview {
    List {
        MotionSection()
    }
}
#endif
