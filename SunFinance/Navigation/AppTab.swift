//
//  AppTab.swift
//  SunFinance
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

enum AppTab: String, CaseIterable, Hashable {
    case watchlist
    case portfolio
    case orders

    var title: LocalizedStringResource {
        switch self {
        case .watchlist:
            AppText.watchlistTab
        case .portfolio:
            AppText.portfolioTab
        case .orders:
            AppText.ordersTab
        }
    }

    var image: FinanceImage {
        switch self {
        case .watchlist:
            .watchlist
        case .portfolio:
            .portfolio
        case .orders:
            .orders
        }
    }
}
