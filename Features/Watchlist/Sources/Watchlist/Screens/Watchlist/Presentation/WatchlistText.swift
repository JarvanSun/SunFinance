//
//  WatchlistText.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

enum WatchlistText {
    static var title: LocalizedStringResource {
        .init("watchlist.title", bundle: .module)
    }

    static var searchPrompt: LocalizedStringResource {
        .init("watchlist.search.prompt", bundle: .module)
    }

    static var sortMenuTitle: LocalizedStringResource {
        .init("watchlist.sort.menu", bundle: .module)
    }

    static var onWatchlistHeading: LocalizedStringResource {
        .init("watchlist.section.onWatchlist", bundle: .module)
    }

    static var symbolMatchesHeading: LocalizedStringResource {
        .init("watchlist.section.symbolMatches", bundle: .module)
    }
}
