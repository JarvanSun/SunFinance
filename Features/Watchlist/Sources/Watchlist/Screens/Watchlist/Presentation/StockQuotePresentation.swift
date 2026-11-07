//
//  StockQuotePresentation.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension StockQuote {
    var trend: GainTrend {
        .init(changePercent)
    }

    var formattedChange: String {
        changePercent.formatted(.signedPercent)
    }

    var accessibilityLabel: LocalizedStringResource {
        let price = price.formatted()
        return .init(
            "watchlist.row.accessibilityLabel \(companyName) \(price) \(formattedChange)",
            bundle: .module
        )
    }
}
