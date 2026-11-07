//
//  QuoteDetailNavigationHost.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

struct QuoteDetailNavigationHost: FeatureHost {
    @State private var router: QuoteDetailRouter
    @State private var viewModel: QuoteDetailViewModel

    var featureRouter: QuoteDetailRouter { router }

    var addContentInNavigationView: Bool { false }

    var root: some View {
        QuoteDetailView(viewModel: viewModel)
    }

    init(dependencies: QuoteDetailDependencies) {
        let router = QuoteDetailRouter(orderTicket: dependencies.orderTicket(for:))
        _router = State(initialValue: router)
        _viewModel = State(initialValue: dependencies.makeViewModel(router: router))
    }
}
