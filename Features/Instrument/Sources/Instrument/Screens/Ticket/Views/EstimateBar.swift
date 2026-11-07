//
//  EstimateBar.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct EstimateBar: View {
    @Environment(\.dimensions) private var dimensions

    let side: TradeSide
    let estimate: EstimateState
    let onReview: () -> Void

    var body: some View {
        VStack(spacing: dimensions.spaceMedium) {
            HStack(alignment: .firstTextBaseline) {
                Text(side.estimateTitle)
                    .textStyle(FinanceColor.textSecondary, FinanceFont.callout)

                Spacer()

                Text(verbatim: estimate.totalText)
                    .textStyle(FinanceColor.textPrimary, FinanceFont.headline)
                    .monospacedDigit()
                    .financeNumberRoll(value: estimate.totalValue)
                    .opacity(estimate.totalOpacity)
                    .financeAnimation(.snappy, value: estimate.isRefreshing)
            }
            .accessibilityElement(children: .combine)

            Button(action: onReview) {
                Text("trading.review.button", bundle: .module)
            }
            .buttonStyle(.finance(.primary))
            .accessibilityIdentifier(InstrumentAccessibility.reviewButton)
        }
        .padding(.horizontal, dimensions.spaceLargeSmall)
        .padding(.vertical, dimensions.spaceMedium)
    }
}
