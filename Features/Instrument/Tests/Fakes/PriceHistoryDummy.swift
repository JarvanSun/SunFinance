//
//  PriceHistoryDummy.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension PriceHistory {
    nonisolated static var dummyAppleDay: PriceHistory {
        .init(
            symbol: "AAPL",
            range: .day,
            currency: .usd,
            baseline: 100,
            candles: [
                .init(
                    start: Date(timeIntervalSince1970: 0),
                    open: 100,
                    high: 106,
                    low: 99,
                    close: 105,
                    volume: 10
                ),
                .init(
                    start: Date(timeIntervalSince1970: 300),
                    open: 105,
                    high: 111,
                    low: 104,
                    close: 110,
                    volume: 12
                ),
            ]
        )
    }
}
