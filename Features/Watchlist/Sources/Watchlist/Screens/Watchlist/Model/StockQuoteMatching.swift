//
//  StockQuoteMatching.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension StockQuote {
    func matches(_ query: String) -> Bool {
        guard !query.isBlank else { return true }

        let matchesSymbol = symbol.rawValue.localizedStandardContains(query)
        let matchesCompanyName = companyName.localizedStandardContains(query)
        return matchesSymbol || matchesCompanyName
    }
}
