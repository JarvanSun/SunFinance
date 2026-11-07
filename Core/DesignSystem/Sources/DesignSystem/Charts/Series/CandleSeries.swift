//
//  CandleSeries.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct CandleSeries: Equatable, Sendable {
    let candles: [ChartCandle]

    var indices: Range<Int> {
        candles.indices
    }

    var scale: ValueScale {
        .init(values: candles.map(\.low) + candles.map(\.high))
    }

    var closePoints: [ChartPoint] {
        candles.map { ChartPoint(date: $0.date, value: $0.close) }
    }

    init(_ candles: [ChartCandle], maximumCount: Int) {
        self.candles = CandleMerging(candles: candles).merged(to: maximumCount)
    }

    func slot(at index: Int) -> String {
        .init(index)
    }

    func slot(of date: Date) -> String {
        slot(at: candles.lastIndex { $0.date <= date } ?? 0)
    }

    func candle(atSlot slot: String?) -> ChartCandle? {
        slot.flatMap(Int.init).flatMap { candles.indices.contains($0) ? candles[$0] : nil }
    }
}

private struct CandleMerging {
    let candles: [ChartCandle]

    func merged(to maximumCount: Int) -> [ChartCandle] {
        guard candles.count > maximumCount, maximumCount > 0 else { return candles }

        let groupSize = Int((Double(candles.count) / Double(maximumCount)).rounded(.up))
        return stride(from: 0, to: candles.count, by: groupSize).map { start in
            ChartCandle(merging: candles[start..<min(start + groupSize, candles.count)])
        }
    }
}

private extension ChartCandle {
    init(merging group: ArraySlice<ChartCandle>) {
        self.init(
            date: group[group.startIndex].date,
            open: group[group.startIndex].open,
            high: group.map(\.high).max() ?? group[group.startIndex].high,
            low: group.map(\.low).min() ?? group[group.startIndex].low,
            close: group[group.endIndex - 1].close,
            volume: group.reduce(0) { $0 + $1.volume }
        )
    }
}
