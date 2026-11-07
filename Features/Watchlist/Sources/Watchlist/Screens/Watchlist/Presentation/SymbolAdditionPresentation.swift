//
//  SymbolAdditionPresentation.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

extension SymbolAddition {
    var image: WatchlistImage {
        switch self {
        case .available:
            .addSymbol
        case .added:
            .symbolAdded
        }
    }

    var imageColor: FinanceColor {
        switch self {
        case .available:
            .accent
        case .added:
            .textSecondary
        }
    }

    var isAvailable: Bool {
        switch self {
        case .available:
            true
        case .added:
            false
        }
    }

    var accessibilityHint: LocalizedStringResource {
        switch self {
        case .available:
            .init("watchlist.match.add.hint", bundle: .module)
        case .added:
            .init("watchlist.match.added.hint", bundle: .module)
        }
    }
}
