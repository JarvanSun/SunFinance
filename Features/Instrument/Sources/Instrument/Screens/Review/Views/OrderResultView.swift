//
//  OrderResultView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct OrderResultView: View {
    @Environment(\.dimensions) private var dimensions

    let outcome: OrderOutcome
    let draft: OrderDraft
    let currency: CurrencyCode
    let onDone: () -> Void
    let onEdit: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: dimensions.spaceXLarge) {
                CompletionBadge(
                    image: outcome.image,
                    color: outcome.color,
                    feedback: outcome.feedback
                )
                .padding(.top, dimensions.spaceXLarge)

                VStack(spacing: dimensions.spaceSmall) {
                    Text(outcome.title(for: draft))
                        .textStyle(FinanceColor.textPrimary, FinanceFont.title)

                    Text(outcome.detail(for: draft, currency: currency))
                        .textStyle(FinanceColor.textSecondary, FinanceFont.body)
                }
                .multilineTextAlignment(.center)
                .accessibilityElement(children: .combine)

                fillRows
            }
            .padding(dimensions.spaceLargeSmall)
            .frame(maxWidth: dimensions.formMaximumWidth)
            .frame(maxWidth: .infinity)
        }
        .floatingBottomBar {
            VStack(spacing: dimensions.spaceSmall) {
                RevealContainer(isRevealed: outcome.allowsEditing) {
                    Button(action: onEdit) {
                        Text("trading.review.edit", bundle: .module)
                    }
                    .buttonStyle(.finance(.primary))
                    .accessibilityIdentifier(InstrumentAccessibility.editButton)
                }

                Button(action: onDone) {
                    Text("trading.result.done", bundle: .module)
                }
                .buttonStyle(.finance(outcome.doneButtonKind))
                .accessibilityIdentifier(InstrumentAccessibility.doneButton)
            }
            .padding(.horizontal, dimensions.spaceLargeSmall)
            .padding(.vertical, dimensions.spaceMedium)
        }
    }
}

private extension OrderResultView {
    @ViewBuilder
    var fillRows: some View {
        switch outcome {
        case .filled(let fill):
            LabeledRows(fill.rows)
        case .filledWithoutDetails, .waitingForPrice, .waitingForTrigger, .scheduled,
            .waitingForOpen, .cancelled, .expired, .rejected:
            EmptyView()
        }
    }
}

#if DEBUG
@available(iOS 26, *)
#Preview("Result", arguments: PreviewObjectPool().outcomes) { outcome in
    OrderResultView(
        outcome: outcome,
        draft: PreviewObjectPool().draft,
        currency: .usd,
        onDone: {},
        onEdit: {}
    )
}
#endif
