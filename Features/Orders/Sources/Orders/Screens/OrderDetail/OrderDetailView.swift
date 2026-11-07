//
//  OrderDetailView.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct OrderDetailView: View {
    @Environment(\.dimensions) private var dimensions

    let viewModel: OrderDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: dimensions.spaceXLarge) {
                header

                ForEach(viewModel.order.detailSections) { section in
                    LabeledRows(section.rows)
                }

                actions
            }
            .padding(dimensions.spaceLargeSmall)
            .frame(maxWidth: dimensions.formMaximumWidth)
            .frame(maxWidth: .infinity)
        }
        .background(FinanceColor.background.color)
        .navigationTitle(Text(OrdersText.detailTitle))
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            Text(OrdersText.cancelConfirmTitle),
            isPresented: isConfirming,
            titleVisibility: .visible
        ) {
            Button(role: .destructive, action: viewModel.confirmCancel) {
                Text(OrdersText.cancelOrder)
            }

            Button(role: .cancel, action: viewModel.dismissCancel) {
                Text(OrdersText.keepOrder)
            }
        } message: {
            Text(OrdersText.cancelConfirmMessage)
        }
        .task(id: viewModel.cancelRequest) { await viewModel.cancelRequestedOrder() }
    }
}

private extension OrderDetailView {
    var header: some View {
        VStack(alignment: .leading, spacing: dimensions.spaceSmall) {
            Text(viewModel.order.headline)
                .textStyle(FinanceColor.textPrimary, FinanceFont.title)

            Label {
                Text(viewModel.order.status.title)
            } icon: {
                Image(style: viewModel.order.status.image)
            }
            .textStyle(viewModel.order.status.color, FinanceFont.headline)
            .id(viewModel.order.status)
            .transition(.identity)

            OrderStatusNoteView(note: viewModel.statusNote)
        }
        .accessibilityElement(children: .combine)
    }

    var actions: some View {
        VStack(spacing: dimensions.spaceSmall) {
            RevealContainer(isRevealed: viewModel.hasCancelFailed) {
                Text(OrdersText.cancelFailed)
                    .textStyle(FinanceColor.critical, FinanceFont.caption)
                    .frame(maxWidth: .infinity)
            }

            RevealContainer(isRevealed: viewModel.canCancel) {
                Button(action: viewModel.requestCancel) {
                    switch viewModel.cancellation {
                    case .working:
                        ProgressView()
                    case .idle, .confirming, .failed:
                        Text(OrdersText.cancelOrder)
                    }
                }
                .buttonStyle(.finance(.destructive))
                .disabled(viewModel.isCancelling)
                .accessibilityIdentifier(OrdersAccessibility.cancelButton)
            }

            Button(action: viewModel.showStock) {
                Text(OrdersText.viewStock)
            }
            .buttonStyle(.finance(.secondary))
            .accessibilityIdentifier(OrdersAccessibility.stockButton)
        }
    }

    var isConfirming: Binding<Bool> {
        Binding(
            get: { viewModel.isConfirmingCancel },
            set: { _ in viewModel.dismissCancel() }
        )
    }
}

#if DEBUG
@available(iOS 26, *)
#Preview("Order Detail", arguments: PreviewObjectPool.sampleOrders) { order in
    NavigationStack {
        OrderDetailView(viewModel: PreviewObjectPool.detailViewModel(order))
    }
}
#endif
