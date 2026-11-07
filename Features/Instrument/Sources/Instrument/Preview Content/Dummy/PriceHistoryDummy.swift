//
//  PriceHistoryDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension PriceHistory {
    nonisolated static func dummy(range: HistoryRange) -> PriceHistory {
        let start = Date(timeIntervalSince1970: 1_793_000_000)
        let candles = (0..<78).map { index in
            let open = Decimal(228 + sin(Double(index) / 7) * 3 + Double(index) * 0.04)
            return PriceCandle(
                start: start.addingTimeInterval(Double(index) * 300),
                open: open,
                high: open + 1,
                low: open - 1,
                close: open + 0.4,
                volume: 1_000
            )
        }
        return .init(
            symbol: "AAPL",
            range: range,
            currency: .usd,
            baseline: 228.5,
            candles: candles
        )
    }
}
#endif
