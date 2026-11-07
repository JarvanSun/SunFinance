//
//  ChartCandleDummy.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import Foundation

extension ChartCandle {
    static var dummyCandles: [ChartCandle] {
        dummyCandles(count: 60)
    }

    static var dummyLongCandles: [ChartCandle] {
        dummyCandles(count: 400)
    }

    private static func dummyCandles(count: Int) -> [ChartCandle] {
        stride(from: 0, to: count, by: 1).map { index in
            let open = 200 + sin(Double(index) / 5) * 8
            let close = open + cos(Double(index) / 3) * 3
            return ChartCandle(
                date: Date.dummyChartStart.addingTimeInterval(Double(index) * 86_400),
                open: open,
                high: max(open, close) + 1.5,
                low: min(open, close) - 1.5,
                close: close,
                volume: 1_000 + abs(sin(Double(index))) * 4_000
            )
        }
    }
}
#endif
