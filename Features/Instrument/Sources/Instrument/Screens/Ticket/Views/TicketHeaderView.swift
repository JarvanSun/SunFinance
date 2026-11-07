//
//  TicketHeaderView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct TicketHeaderView: View {
    @Environment(\.dimensions) private var dimensions

    let context: TicketContext
    let side: TradeSide

    var body: some View {
        VStack(alignment: .leading, spacing: dimensions.spaceXSmall) {
            Text(verbatim: context.quote.companyName)
                .textStyle(FinanceColor.textSecondary, FinanceFont.callout)

            Text(verbatim: context.priceText)
                .textStyle(FinanceColor.textPrimary, FinanceFont.priceLarge)
                .monospacedDigit()
                .financeNumberRoll(value: context.priceValue)

            Text(context.holdingsText(for: side))
                .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
                .monospacedDigit()
                .id(side)

            switch context.marketNotice {
            case .some(let notice):
                marketNotice(notice)
            case nil:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

private extension TicketHeaderView {
    func marketNotice(_ notice: LocalizedStringResource) -> some View {
        Label {
            Text(notice)
        } icon: {
            Image(style: FinanceImage.scheduled)
        }
        .textStyle(FinanceColor.textSecondary, FinanceFont.caption)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 24) {
        TicketHeaderView(context: .dummy(isMarketOpen: true), side: .buy)

        TicketHeaderView(context: .dummy(isMarketOpen: false), side: .sell)
    }
    .padding()
}
#endif
