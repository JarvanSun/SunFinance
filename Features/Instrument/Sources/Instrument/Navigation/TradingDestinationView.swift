//
//  TradingDestinationView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import SunUserInterface
import SwiftUI

struct TradingDestinationView: FeatureDestinationView {
    let destination: TradingDestination
    let makeReviewViewModel: ((OrderDraft) -> ReviewViewModel)?

    var body: some View {
        switch (destination, makeReviewViewModel) {
        case (.review(let draft), .some(let makeViewModel)):
            ReviewHost(viewModel: makeViewModel(draft))
        case (.root, _), (.review, nil):
            EmptyView()
        }
    }
}

private struct ReviewHost: View {
    @State private var viewModel: ReviewViewModel

    init(viewModel: @autoclosure () -> ReviewViewModel) {
        _viewModel = State(initialValue: viewModel())
    }

    var body: some View {
        ReviewView(viewModel: viewModel)
    }
}
