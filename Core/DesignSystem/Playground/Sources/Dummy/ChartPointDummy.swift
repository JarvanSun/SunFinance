//
//  ChartPointDummy.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension ChartPoint {
    static func dummySeries(for range: HistoryRange) -> [ChartPoint] {
        let count = dummyCount(for: range)
        let start = Date(timeIntervalSince1970: 1_793_000_000)
        return (0..<count).map { index in
            let progress = Double(index) / Double(count)
            let value = 200 + sin(progress * 9) * 12 + sin(progress * 47) * 3 + progress * 18
            return ChartPoint(date: start.addingTimeInterval(Double(index) * 300), value: value)
        }
    }

    private static func dummyCount(for range: HistoryRange) -> Int {
        switch range {
        case .day: 78
        case .week: 130
        case .month: 154
        case .threeMonths: 63
        case .year: 252
        case .fiveYears: 1_260
        }
    }
}
