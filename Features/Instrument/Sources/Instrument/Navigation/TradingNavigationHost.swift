//
//  TradingNavigationHost.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

struct TradingNavigationHost: FeatureHost {
    @State private var router: TradingRouter
    @State private var viewModel: TicketViewModel

    var featureRouter: TradingRouter { router }

    var root: some View {
        TicketView(viewModel: viewModel)
            .dismissesSheet(on: router.closeRequest)
    }

    init(dependencies: TradingDependencies) {
        let router = TradingRouter()
        let keys = PlacementKeys()
        router.makeReviewViewModel = { [unowned router] draft in
            dependencies.makeReviewViewModel(draft: draft, keys: keys, router: router)
        }
        _router = State(initialValue: router)
        _viewModel = State(initialValue: dependencies.makeTicketViewModel(router: router))
    }
}

private extension View {
    func dismissesSheet(on request: Int) -> some View {
        modifier(DismissOnRequest(request: request))
    }
}

private struct DismissOnRequest: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    let request: Int

    func body(content: Content) -> some View {
        content.onChange(of: request) { dismiss() }
    }
}
