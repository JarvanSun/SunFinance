//
//  OrdersNavigationHost.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

struct OrdersNavigationHost: FeatureHost {
    @State private var router: OrdersRouter
    @State private var viewModel: OrdersViewModel

    var featureRouter: OrdersRouter { router }

    var root: some View {
        OrdersView(viewModel: viewModel)
    }

    init(dependencies: OrdersDependencies) {
        let router = OrdersRouter(quoteDetail: dependencies.quoteDetail)
        let viewModel = dependencies.makeViewModel(router: router)
        router.makeDetailViewModel = { [unowned router, weak viewModel] order in
            dependencies.makeDetailViewModel(order: order, router: router) {
                viewModel?.replace($0)
            }
        }
        _router = State(initialValue: router)
        _viewModel = State(initialValue: viewModel)
    }
}
