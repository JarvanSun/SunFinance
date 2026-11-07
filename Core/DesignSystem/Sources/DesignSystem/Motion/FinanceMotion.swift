//
//  FinanceMotion.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public enum FinanceMotion: CaseIterable, Sendable {
    case snappy
    case settle
    case reveal
    case emphasis
    case draw
    case shake
    case shimmer
    case pulse

    public var animation: Animation {
        switch self {
        case .snappy: .snappy(duration: duration)
        case .settle, .emphasis: .spring(duration: duration, bounce: bounce)
        case .reveal: .smooth(duration: duration)
        case .draw: .easeOut(duration: duration)
        case .shake: .linear(duration: duration)
        case .shimmer: .linear(duration: duration).repeatForever(autoreverses: false)
        case .pulse: .easeOut(duration: duration).repeatForever(autoreverses: false)
        }
    }

    public var duration: TimeInterval {
        switch self {
        case .snappy: 0.25
        case .settle: 0.45
        case .reveal: 0.35
        case .emphasis: 0.6
        case .draw: 0.9
        case .shake: 0.06
        case .shimmer: 2.4
        case .pulse: 2
        }
    }

    public func animation(reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : animation
    }
}

extension FinanceMotion {
    var bounce: Double {
        switch self {
        case .snappy, .reveal, .draw, .shake, .shimmer, .pulse: 0
        case .settle: 0.15
        case .emphasis: 0.35
        }
    }
}

#if DEBUG
private struct FinanceMotionPreview: View {
    @State private var isMoved = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(FinanceMotion.allCases, id: \.self) { motion in
                VStack(alignment: .leading, spacing: 4) {
                    Text(verbatim: "\(motion) \(motion.duration)s")
                        .textStyle(FinanceColor.textSecondary, FinanceFont.caption)

                    Circle()
                        .fill(FinanceColor.accent.color)
                        .frame(width: 20, height: 20)
                        .frame(maxWidth: .infinity, alignment: isMoved ? .trailing : .leading)
                        .animation(motion.animation, value: isMoved)
                }
            }

            Button(action: { isMoved.toggle() }) {
                Text(verbatim: "Play")
            }
            .buttonStyle(.finance(.primary))
        }
        .padding()
    }
}

#Preview("Motion") {
    FinanceMotionPreview()
}
#endif
