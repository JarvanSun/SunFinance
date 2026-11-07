//
//  StockQuoteDummy.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension StockQuote {
    static var dummyGaining: StockQuote {
        .init(
            symbol: "AAPL",
            companyName: "Apple Inc.",
            price: Money(228.52, .usd),
            changePercent: 1.24,
            marketCap: Money(3_450_000_000_000, .usd)
        )
    }

    static var dummyLosing: StockQuote {
        .init(
            symbol: "SAP",
            companyName: "SAP SE",
            price: Money(221.35, .eur),
            changePercent: -0.38,
            marketCap: Money(271_000_000_000, .eur)
        )
    }

    static var dummyUnchanged: StockQuote {
        .init(
            symbol: "ALV",
            companyName: "Allianz SE",
            price: Money(289.90, .eur),
            changePercent: 0,
            marketCap: Money(113_000_000_000, .eur)
        )
    }

    static var dummyWatchlist: [StockQuote] {
        [.dummyGaining, .dummyLosing, .dummyUnchanged]
    }
}
#endif
