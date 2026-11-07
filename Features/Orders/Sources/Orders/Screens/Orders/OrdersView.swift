//
//  OrdersView.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct OrdersView: View {
    @Environment(\.dimensions) private var dimensions
    @State private var reloadRequest = 0
    @State private var pageRetryRequest = 0

    let viewModel: OrdersViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                Section {
                    LazyVStack(alignment: .leading, spacing: dimensions.spaceLargeExtra) {
                        ForEach(viewModel.days) { day in
                            dayGroup(day)
                        }

                        switch viewModel.footer {
                        case .some(let footer):
                            OrdersFooterView(footer: footer, onRetry: requestPageRetry)
                        case nil:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal, dimensions.spaceLargeSmall)
                    .padding(.top, dimensions.spaceMedium)
                    .padding(.bottom, dimensions.spaceXXLarge)
                } header: {
                    filterPicker
                }
            }
        }
        .overlay(if: viewModel.placeholder) { placeholder in
            OrdersPlaceholderView(placeholder: placeholder, onRetry: requestReload)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(FinanceColor.background.color)
        .navigationTitle(Text("orders.title", bundle: .module))
        .refreshable { await viewModel.refresh() }
        .task(id: LoadRequest(filter: viewModel.filter, count: reloadRequest)) {
            await viewModel.load()
        }
        .task(id: pageRetryRequest) { await viewModel.retryPage() }
        .onAppear(perform: viewModel.trackScreenView)
    }
}

private extension OrdersView {
    struct LoadRequest: Equatable {
        let filter: OrderListFilter
        let count: Int
    }

    var filterPicker: some View {
        FinanceSegmentedControl(
            options: OrderListFilter.allCases,
            selection: viewModel.filter,
            style: .quiet,
            onSelect: viewModel.selectFilter
        ) {
            Text($0.title)
        }
        .padding(.horizontal, dimensions.spaceLargeSmall)
        .padding(.vertical, dimensions.spaceSmall)
        .background(FinanceColor.background.color)
        .accessibilityIdentifier(OrdersAccessibility.filterPicker)
    }

    func dayGroup(_ day: OrderDay) -> some View {
        VStack(alignment: .leading, spacing: dimensions.spaceSmall) {
            Text(day.heading.title)
                .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
                .padding(.horizontal, dimensions.spaceXSmall)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 0) {
                ForEach(day.orders) { order in
                    Button {
                        viewModel.open(order)
                    } label: {
                        OrderRowView(order: order)
                    }
                    .buttonStyle(.finance(.row))
                    .accessibilityIdentifier(OrdersAccessibility.orderRow)
                    .task { await viewModel.loadMore(reaching: order) }
                }
            }
        }
    }

    func requestReload() {
        reloadRequest += 1
    }

    func requestPageRetry() {
        pageRetryRequest += 1
    }
}

#if DEBUG
@available(iOS 26, *)
#Preview("Orders", arguments: OrdersPreviewState.allCases) { state in
    NavigationStack {
        OrdersView(viewModel: PreviewObjectPool().ordersViewModel(state))
    }
    .environment(\.locale, state.locale)
}
#endif
