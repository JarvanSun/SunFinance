//
//  FavoriteActionPresentation.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

extension FavoriteAction {
    var title: LocalizedStringResource {
        switch self {
        case .add: .init("watchlist.favorite.add", bundle: .module)
        case .remove: .init("watchlist.favorite.remove", bundle: .module)
        }
    }

    var swipeImage: FinanceImage {
        switch self {
        case .add: .favorite
        case .remove: .removeFavorite
        }
    }

    var rowBadge: FinanceImage? {
        switch self {
        case .add: nil
        case .remove: .favorite
        }
    }
}
