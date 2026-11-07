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
        case .day: .init("charts.range.day.short", bundle: .module)
        case .week: .init("charts.range.week.short", bundle: .module)
        case .month: .init("charts.range.month.short", bundle: .module)
        case .threeMonths: .init("charts.range.threeMonths.short", bundle: .module)
        case .year: .init("charts.range.year.short", bundle: .module)
        case .fiveYears: .init("charts.range.fiveYears.short", bundle: .module)
        }
    }

    public var accessibilityTitle: LocalizedStringResource {
        switch self {
        case .day: .init("charts.range.day", bundle: .module)
        case .week: .init("charts.range.week", bundle: .module)
        case .month: .init("charts.range.month", bundle: .module)
        case .threeMonths: .init("charts.range.threeMonths", bundle: .module)
        case .year: .init("charts.range.year", bundle: .module)
        case .fiveYears: .init("charts.range.fiveYears", bundle: .module)
        }
    }
}
