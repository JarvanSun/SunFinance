//
//  OrdersDestinationView.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct OrdersDestinationView: FeatureDestinationView {
    let destination: OrdersDestination
    let quoteDetail: FeatureEntry<TickerSymbol>
    let makeDetailViewModel: ((Order) -> OrderDetailViewModel)?

    var body: some View {
        switch (destination, makeDetailViewModel) {
        case (.detail(let order), .some(let makeViewModel)):
            OrderDetailHost(viewModel: makeViewModel(order))
        case (.quoteDetail(let symbol), _):
            quoteDetail.view(for: symbol)
        case (.root, _), (.detail, nil):
            EmptyView()
        }
    }
}

private struct OrderDetailHost: View {
    @State private var viewModel: OrderDetailViewModel

    init(viewModel: @autoclosure () -> OrderDetailViewModel) {
        _viewModel = State(initialValue: viewModel())
    }

    var body: some View {
        OrderDetailView(viewModel: viewModel)
    }
}
