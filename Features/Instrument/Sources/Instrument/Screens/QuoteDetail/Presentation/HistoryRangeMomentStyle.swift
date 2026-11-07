//
//  HistoryRangeMomentStyle.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension HistoryRange {
    var momentStyle: Date.FormatStyle {
        switch self {
        case .day:
            .dateTime.hour().minute()
        case .week, .month:
            .dateTime.weekday(.abbreviated).day().month(.abbreviated).hour().minute()
        case .threeMonths, .year, .fiveYears:
            .dateTime.day().month(.abbreviated).year()
        }
    }
}
