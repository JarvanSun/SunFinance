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
        ValueScale(values: candles.map(\.low) + candles.map(\.high))
    }

    var closePoints: [ChartPoint] {
        candles.map { ChartPoint(date: $0.date, value: $0.close) }
    }

    static var maximumCount: Int { 90 }

    init(_ candles: [ChartCandle], maximumCount: Int) {
        self.candles = Self.merged(candles, to: maximumCount)
    }

    func slot(at index: Int) -> String {
        String(index)
    }

    func slot(of date: Date) -> String {
        slot(at: candles.lastIndex { $0.date <= date } ?? 0)
    }

    func candle(atSlot slot: String?) -> ChartCandle? {
        slot.flatMap(Int.init).flatMap { candles.indices.contains($0) ? candles[$0] : nil }
    }
}

private extension CandleSeries {
    static func merged(_ candles: [ChartCandle], to maximumCount: Int) -> [ChartCandle] {
        guard candles.count > maximumCount, maximumCount > 0 else { return candles }

        let groupSize = Int((Double(candles.count) / Double(maximumCount)).rounded(.up))
        return stride(from: 0, to: candles.count, by: groupSize).map { start in
            merged(candles[start..<min(start + groupSize, candles.count)])
        }
    }

    static func merged(_ group: ArraySlice<ChartCandle>) -> ChartCandle {
        ChartCandle(
            date: group[group.startIndex].date,
            open: group[group.startIndex].open,
            high: group.map(\.high).max() ?? group[group.startIndex].high,
            low: group.map(\.low).min() ?? group[group.startIndex].low,
            close: group[group.endIndex - 1].close,
            volume: group.reduce(0) { $0 + $1.volume }
        )
    }
}
