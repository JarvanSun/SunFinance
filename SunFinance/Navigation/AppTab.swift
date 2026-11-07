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
        case .watchlist: .init("app.tab.watchlist")
        case .portfolio: .init("app.tab.portfolio")
        case .orders: .init("app.tab.orders")
        }
    }

    var image: FinanceImage {
        switch self {
        case .watchlist: .watchlist
        case .portfolio: .portfolio
        case .orders: .orders
        }
    }
}
