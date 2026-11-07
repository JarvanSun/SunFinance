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
        .navigationTitle(Text("orders.detail.title", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            Text("orders.detail.cancel.confirm.title", bundle: .module),
            isPresented: isConfirming,
            titleVisibility: .visible
        ) {
            Button(role: .destructive, action: viewModel.confirmCancel) {
                Text("orders.detail.cancel", bundle: .module)
            }

            Button(role: .cancel, action: viewModel.dismissCancel) {
                Text("orders.detail.cancel.keep", bundle: .module)
            }
        } message: {
            Text("orders.detail.cancel.confirm.message", bundle: .module)
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
                Text("orders.detail.cancel.failed", bundle: .module)
                    .textStyle(FinanceColor.critical, FinanceFont.caption)
                    .frame(maxWidth: .infinity)
            }

            RevealContainer(isRevealed: viewModel.canCancel) {
                Button(action: viewModel.requestCancel) {
                    switch viewModel.cancellation {
                    case .working:
                        ProgressView()
                    case .idle, .confirming, .failed:
                        Text("orders.detail.cancel", bundle: .module)
                    }
                }
                .buttonStyle(.finance(.destructive))
                .disabled(viewModel.isCancelling)
                .accessibilityIdentifier(OrdersAccessibility.cancelButton)
            }

            Button(action: viewModel.showStock) {
                Text("orders.detail.stock", bundle: .module)
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
#Preview("Order Detail", arguments: PreviewObjectPool().sampleOrders) { order in
    NavigationStack {
        OrderDetailView(viewModel: PreviewObjectPool().detailViewModel(order))
    }
}
#endif
