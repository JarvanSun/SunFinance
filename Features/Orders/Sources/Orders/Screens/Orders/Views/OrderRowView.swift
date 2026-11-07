//
//  OrderRowView.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct OrderRowView: View {
    @Environment(\.dimensions) private var dimensions

    let order: Order

    var body: some View {
        HStack(spacing: dimensions.spaceMedium) {
            VStack(alignment: .leading, spacing: dimensions.spaceXSmall) {
                Text(verbatim: order.draft.symbol.rawValue)
                    .textStyle(FinanceColor.textPrimary, FinanceFont.headline)

                Text(order.rowSubtitle)
                    .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
                    .lineLimit(1)
            }
            .layoutPriority(1)

            Spacer(minLength: dimensions.spaceSmall)

            VStack(alignment: .trailing, spacing: dimensions.spaceXSmall) {
                switch order.settledTotal {
                case .some(let total):
                    Text(verbatim: total)
                        .textStyle(FinanceColor.textPrimary, FinanceFont.headline)
                        .monospacedDigit()
                case nil:
                    Text(order.status.title)
                        .textStyle(order.status.color, FinanceFont.headline)
                }

                Text(order.rowKind)
                    .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
                    .monospacedDigit()
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, dimensions.spaceSmall)
        .padding(.vertical, dimensions.spaceMedium)
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(order.accessibilityLabel))
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 0) {
        ForEach(PreviewObjectPool.sampleOrders) { order in
            OrderRowView(order: order)
        }
    }
    .padding()
}
#endif
