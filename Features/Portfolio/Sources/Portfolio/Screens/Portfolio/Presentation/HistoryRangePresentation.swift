//
//  HistoryRangePresentation.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension HistoryRange {
    var periodTitle: LocalizedStringResource {
        switch self {
        case .day:
            .init("portfolio.period.day", bundle: .module)
        case .week:
            .init("portfolio.period.week", bundle: .module)
        case .month:
            .init("portfolio.period.month", bundle: .module)
        case .threeMonths:
            .init("portfolio.period.threeMonths", bundle: .module)
        case .year:
            .init("portfolio.period.year", bundle: .module)
        case .fiveYears:
            .init("portfolio.period.fiveYears", bundle: .module)
        }
    }

    func chartSummary(from first: String, to last: String) -> LocalizedStringResource {
        switch self {
        case .day:
            .init("portfolio.chart.summary.day \(first) \(last)", bundle: .module)
        case .week:
            .init("portfolio.chart.summary.week \(first) \(last)", bundle: .module)
        case .month:
            .init("portfolio.chart.summary.month \(first) \(last)", bundle: .module)
        case .threeMonths:
            .init("portfolio.chart.summary.threeMonths \(first) \(last)", bundle: .module)
        case .year:
            .init("portfolio.chart.summary.year \(first) \(last)", bundle: .module)
        case .fiveYears:
            .init("portfolio.chart.summary.fiveYears \(first) \(last)", bundle: .module)
        }
    }

    var axisDate: @Sendable (Date) -> String {
        switch self {
        case .day:
            { $0.formatted(date: .omitted, time: .shortened) }
        case .week:
            { $0.formatted(.dateTime.weekday(.abbreviated)) }
        case .month, .threeMonths:
            { $0.formatted(.dateTime.day().month(.abbreviated)) }
        case .year, .fiveYears:
            { $0.formatted(.dateTime.month(.abbreviated).year()) }
        }
    }
}
