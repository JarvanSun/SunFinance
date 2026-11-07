//
//  WatchlistNavigationHost.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

struct WatchlistNavigationHost: FeatureHost {
    @State private var router: WatchlistRouter
    @State private var viewModel: WatchlistViewModel

    var featureRouter: WatchlistRouter { router }

    var root: some View {
        WatchlistView(viewModel: viewModel)
    }

    init(dependencies: WatchlistDependencies) {
        let router = WatchlistRouter(quoteDetail: dependencies.quoteDetail)
        _router = State(initialValue: router)
        _viewModel = State(initialValue: dependencies.makeViewModel(router: router))
    }
}
