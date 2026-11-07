//
//  LiveDot.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

struct LiveDot: View {
    @Environment(\.dimensions) private var dimensions
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let color: FinanceColor

    var body: some View {
        ZStack {
            if !reduceMotion {
                TimelineView(.animation) { timeline in
                    let phase = phase(at: timeline.date)
                    Circle()
                        .fill(color.color.opacity(ringOpacity * (1 - phase)))
                        .scaleEffect(1 + phase * ringGrowth)
                }
            }

            Circle()
                .fill(color.color)
                .overlay(
                    Circle()
                        .stroke(FinanceColor.surface.color, lineWidth: dimensions.chartLineWidth)
                )
        }
        .frame(width: dimensions.chartLiveDotSize, height: dimensions.chartLiveDotSize)
        .accessibilityHidden(true)
    }
}

private extension LiveDot {
    var period: TimeInterval { FinanceMotion.pulse.duration }

    var ringOpacity: Double { 0.35 }

    var ringGrowth: CGFloat { 2.2 }

    func phase(at date: Date) -> CGFloat {
        date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: period) / period
    }
}

#if DEBUG
#Preview {
    HStack(spacing: 32) {
        LiveDot(color: .gain)

        LiveDot(color: .loss)
    }
    .padding()
}
#endif
