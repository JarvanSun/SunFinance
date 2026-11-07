//
//  WatchlistPlaceholderPresentation.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension WatchlistPlaceholder {
    var title: LocalizedStringResource {
        switch self {
        case .loading: .init("watchlist.placeholder.loading.title", bundle: .module)
        case .searching: .init("watchlist.placeholder.searching.title", bundle: .module)
        case .unavailable(let reason): reason.title
        }
    }
}
