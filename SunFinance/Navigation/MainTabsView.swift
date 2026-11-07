//
//  MainTabsView.swift
//  SunFinance
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Orders
import Portfolio
import SunUserInterface
import SwiftUI
import Watchlist

struct MainTabsView: View {
    @State private var selection = AppTab.watchlist

    let dependencies: AppDependencies

    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Tab(value: tab) {
                    screen(for: tab)
                } label: {
                    Label {
                        Text(tab.title)
                    } icon: {
                        Image(style: tab.image)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func screen(for tab: AppTab) -> some View {
        switch tab {
        case .watchlist:
            WatchlistHostView(dependencies: dependencies.watchlist())
        case .portfolio:
            PortfolioHostView(dependencies: dependencies.portfolio())
        case .orders:
            OrdersHostView(dependencies: dependencies.orders())
        }
    }
}
