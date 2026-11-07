//
//  TradeActionsView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct TradeActionsView: View {
    @Environment(\.dimensions) private var dimensions

    let actions: [TradeAction]
    let onTrade: (TradeSide) -> Void

    var body: some View {
        HStack(spacing: dimensions.spaceMedium) {
            ForEach(actions) { action in
                Button(action: { onTrade(action.side) }) {
                    TradeButtonLabel(action: action)
                }
                .buttonStyle(.finance(.row))
                .accessibilityIdentifier(action.side.accessibilityIdentifier)
            }
        }
        .padding(.horizontal, dimensions.spaceLargeSmall)
        .padding(.vertical, dimensions.spaceSmall)
    }
}

private struct TradeButtonLabel: View {
    @Environment(\.dimensions) private var dimensions

    let action: TradeAction

    var body: some View {
        VStack(spacing: dimensions.borderWidthMedium) {
            Text(action.side.actionTitle)
                .font(FinanceFont.headline)

            Text(verbatim: action.price.formatted())
                .font(FinanceFont.caption)
                .monospacedDigit()
                .opacity(priceOpacity)
        }
        .foregroundColor(FinanceColor.textOnAccent)
        .frame(maxWidth: .infinity, minHeight: dimensions.actionButtonHeight)
        .background(shape.fill(action.side.fill.color))
        .contentShape(shape)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: dimensions.cornerRadiusLarge, style: .continuous)
    }

    private var priceOpacity: Double { 0.85 }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        TradeActionsView(
            actions: [TradeAction(side: .buy, price: Money(231.42, .usd))],
            onTrade: { _ in }
        )

        TradeActionsView(
            actions: [
                TradeAction(side: .sell, price: Money(231.42, .usd)),
                TradeAction(side: .buy, price: Money(231.42, .usd)),
            ],
            onTrade: { _ in }
        )
    }
}
#endif
