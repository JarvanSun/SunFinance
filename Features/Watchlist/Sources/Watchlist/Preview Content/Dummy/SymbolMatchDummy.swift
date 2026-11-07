//
//  SymbolMatchDummy.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore

extension SymbolMatch {
    static var dummyTesla: SymbolMatch {
        .init(symbol: "TSLA", companyName: "Tesla, Inc.", exchange: "NASDAQ", currency: .usd)
    }

    static var dummySiemens: SymbolMatch {
        .init(symbol: "SIE", companyName: "Siemens AG", exchange: "XETRA", currency: .eur)
    }

    static var dummySearchResults: [SymbolMatch] {
        [.dummyTesla, .dummySiemens]
    }
}
#endif
