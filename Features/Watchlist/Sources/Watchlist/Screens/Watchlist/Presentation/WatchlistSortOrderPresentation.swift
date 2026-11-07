//
//  WatchlistSortOrderPresentation.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension WatchlistSortOrder {
    var title: LocalizedStringResource {
        switch self {
        case .marketCap:
            .init("watchlist.sort.marketCap", bundle: .module)
        case .dailyChange:
            .init("watchlist.sort.dailyChange", bundle: .module)
        case .symbol:
            .init("watchlist.sort.symbol", bundle: .module)
        }
    }
}
