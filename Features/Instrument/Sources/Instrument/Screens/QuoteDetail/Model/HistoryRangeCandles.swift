//
//  HistoryRangeCandles.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

extension HistoryRange {
    var isLongEnoughForCandles: Bool {
        switch self {
        case .day, .week: false
        case .month, .threeMonths, .year, .fiveYears: true
        }
    }
}
