//
//  StockQuoteDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension StockQuote {
    nonisolated static func dummy(isMarketOpen: Bool = true) -> StockQuote {
        .init(
            symbol: "AAPL",
            companyName: "Apple Inc.",
            price: Money(231.42, .usd),
            changePercent: 1.27,
            marketCap: Money(3_450_000_000_000, .usd),
            isMarketOpen: isMarketOpen
        )
    }
}
#endif
