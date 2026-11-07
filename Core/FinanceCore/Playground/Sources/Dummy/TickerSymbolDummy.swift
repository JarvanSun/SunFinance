//
//  TickerSymbolDummy.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

extension TickerSymbol {
    static var dummyWatchlist: [TickerSymbol] {
        ["AAPL", "MSFT", "NVDA", "SAP", "SIE", "ALV"]
    }

    static var dummyShortWatchlist: [TickerSymbol] {
        ["AAPL", "SAP"]
    }

    static var dummyExchangeListing: [TickerSymbol] {
        ["AAPL", "MSFT", "NVDA", "TSLA", "KO", "JPM", "SAP", "SIE", "ALV"]
    }
}
