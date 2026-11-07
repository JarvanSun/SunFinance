//
//  PortfolioNavigationHost.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

struct PortfolioNavigationHost: FeatureHost {
    @State private var router: PortfolioRouter
    @State private var viewModel: PortfolioViewModel

    var featureRouter: PortfolioRouter { router }

    var root: some View {
        PortfolioView(viewModel: viewModel)
    }

    init(dependencies: PortfolioDependencies) {
        let router = PortfolioRouter(
            quoteDetail: dependencies.quoteDetail,
            orderTicket: dependencies.orderTicket
        )
        _router = State(initialValue: router)
        _viewModel = State(initialValue: dependencies.makeViewModel(router: router))
    }
}
