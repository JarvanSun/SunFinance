//
//  ChartCandleDummy.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

@testable import DesignSystem

extension ChartCandle {
    static func dummySeries(count: Int) -> [ChartCandle] {
        (0..<count).map { index in
            let base = 10 + Double(index)
            return ChartCandle(
                date: Date(timeIntervalSince1970: Double(index) * 86_400),
                open: base,
                high: base + 2,
                low: base - 1,
                close: base + 1,
                volume: 100
            )
        }
    }
}
