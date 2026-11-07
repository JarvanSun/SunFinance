//
//  TradeIntentDummy.swift
//  InstrumentPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

extension TradeIntent {
    static var dummyIntents: [TradeIntent] {
        [
            .init(symbol: "AAPL", side: .buy, source: .quoteDetail),
            .init(symbol: "SAP", side: .buy, source: .quoteDetail),
            .init(symbol: "SAP", side: .sell, source: .quoteDetail),
            .init(symbol: "NVDA", side: .sell, source: .quoteDetail),
            .init(symbol: "TSLA", side: .buy, source: .quoteDetail),
        ]
    }
}
