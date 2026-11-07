//
//  DecimalFieldRow.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct DecimalFieldRow: View {
    let field: TicketField
    let title: LocalizedStringResource
    @Binding var text: String
    let issue: TicketIssue?
    let shakeCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DecimalField(title, text: $text, isInvalid: isInvalid)
                .accessibilityIdentifier(field.accessibilityIdentifier)

            FieldIssueView(field: field, issue: issue, shakeCount: shakeCount)
        }
        .id(field)
    }
}

private extension DecimalFieldRow {
    var isInvalid: Bool {
        issue != nil
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 24) {
        DecimalFieldRow(
            field: .amount,
            title: AmountMode.shares.fieldTitle,
            text: .constant("2"),
            issue: nil,
            shakeCount: 0
        )

        DecimalFieldRow(
            field: .amount,
            title: AmountMode.shares.fieldTitle,
            text: .constant("200"),
            issue: .insufficientCash,
            shakeCount: 0
        )

        DecimalFieldRow(
            field: .limitPrice,
            title: TradeSide.buy.limitFieldTitle,
            text: .constant(""),
            issue: .missing,
            shakeCount: 0
        )
    }
    .padding()
}
#endif
