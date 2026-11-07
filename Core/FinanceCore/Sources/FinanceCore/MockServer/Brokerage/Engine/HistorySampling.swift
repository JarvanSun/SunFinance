//
//  HistorySampling.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct HistorySampling: Equatable, Sendable {
    let range: HistoryRange

    var sampleCount: Int { 120 }

    var span: TimeInterval {
        switch range {
        case .day:
            day
        case .week:
            7 * day
        case .month:
            30 * day
        case .threeMonths:
            91 * day
        case .year:
            365 * day
        case .fiveYears:
            1_826 * day
        }
    }

    func moments(endingAt date: Date) -> [Date] {
        switch range {
        case .day, .week:
            let start = date.addingTimeInterval(-span)
            let step = span / Double(sampleCount - 1)
            return (0..<sampleCount).map { start.addingTimeInterval(Double($0) * step) }
        case .month, .threeMonths, .year, .fiveYears:
            return closingMoments(endingAt: date) + [date]
        }
    }
}

private extension HistorySampling {
    var day: TimeInterval { 86_400 }

    var closingOffset: TimeInterval { 21 * 3_600 + 15 * 60 }

    var sunday: Int { 1 }

    var friday: Int { 6 }

    var saturday: Int { 7 }

    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        return calendar
    }

    func closingMoments(endingAt date: Date) -> [Date] {
        let calendar = calendar
        let firstDay = calendar.startOfDay(for: date.addingTimeInterval(-span))
        let days = Int(span / day) + 1
        return (0...days)
            .compactMap {
                calendar.date(byAdding: .day, value: $0, to: firstDay)?
                    .addingTimeInterval(closingOffset)
            }
            .filter { $0 < date && isSampled(weekday: calendar.component(.weekday, from: $0)) }
    }

    func isSampled(weekday: Int) -> Bool {
        switch range {
        case .fiveYears:
            weekday == friday
        case .day, .week, .month, .threeMonths, .year:
            weekday != sunday && weekday != saturday
        }
    }
}
