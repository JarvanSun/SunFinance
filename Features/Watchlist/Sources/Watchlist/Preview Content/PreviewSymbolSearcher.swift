//
//  PreviewSymbolSearcher.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

struct PreviewSymbolSearcher: SymbolSearching {
    let result: Result<[SymbolMatch], MarketDataError>

    func symbols(matching query: String) async throws(MarketDataError) -> [SymbolMatch] {
        try result.get().filter {
            $0.symbol.rawValue.localizedStandardContains(query)
                || $0.companyName.localizedStandardContains(query)
        }
    }
}
#endif
