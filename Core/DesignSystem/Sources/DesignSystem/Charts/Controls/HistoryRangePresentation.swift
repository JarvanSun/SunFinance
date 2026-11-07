//
//  HistoryRangePresentation.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension HistoryRange {
    var shortTitle: LocalizedStringResource {
        switch self {
        case .day:
            .init("charts.range.day.short", bundle: .designSystem)
        case .week:
            .init("charts.range.week.short", bundle: .designSystem)
        case .month:
            .init("charts.range.month.short", bundle: .designSystem)
        case .threeMonths:
            .init("charts.range.threeMonths.short", bundle: .designSystem)
        case .year:
            .init("charts.range.year.short", bundle: .designSystem)
        case .fiveYears:
            .init("charts.range.fiveYears.short", bundle: .designSystem)
        }
    }

    public var accessibilityTitle: LocalizedStringResource {
        switch self {
        case .day:
            .init("charts.range.day", bundle: .designSystem)
        case .week:
            .init("charts.range.week", bundle: .designSystem)
        case .month:
            .init("charts.range.month", bundle: .designSystem)
        case .threeMonths:
            .init("charts.range.threeMonths", bundle: .designSystem)
        case .year:
            .init("charts.range.year", bundle: .designSystem)
        case .fiveYears:
            .init("charts.range.fiveYears", bundle: .designSystem)
        }
    }
}
