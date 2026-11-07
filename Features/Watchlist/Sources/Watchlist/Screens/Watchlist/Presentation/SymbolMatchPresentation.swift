//
//  SymbolMatchPresentation.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension SymbolMatch {
    var listing: LocalizedStringResource {
        .init("watchlist.match.listing \(symbol.rawValue) \(exchange)", bundle: .module)
    }

    var accessibilityLabel: LocalizedStringResource {
        .init(
            "watchlist.match.accessibilityLabel \(companyName) \(symbol.rawValue) \(exchange)",
            bundle: .module
        )
    }
}
