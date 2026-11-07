//
//  TradingVenue.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

enum TradingVenue: String, Codable, CaseIterable, Sendable {
    case nasdaq
    case nyse
    case xetra

    func isOpen(at date: Date) -> Bool {
        let session = session(onDayOf: date)
        return session.map { $0.contains(date) } ?? false
    }

    func closes(atOrBefore date: Date) -> [Date] {
        (0..<searchedDays)
            .compactMap { calendar.date(byAdding: .day, value: -$0, to: date) }
            .compactMap(session(onDayOf:))
            .map(\.upperBound)
            .filter { $0 <= date }
    }

    func sessions(endingAtOrBefore date: Date, count: Int) -> [Range<Date>] {
        let searched = count * daysPerWeek / tradingDaysPerWeek + searchedDays
        let started = (0..<searched)
            .compactMap { calendar.date(byAdding: .day, value: -$0, to: date) }
            .compactMap(session(onDayOf:))
            .filter { $0.lowerBound < date }
            .map { $0.lowerBound..<min($0.upperBound, date) }
        return Array(started.prefix(count).reversed())
    }
}

private extension TradingVenue {
    var searchedDays: Int { 10 }

    var daysPerWeek: Int { 7 }

    var tradingDaysPerWeek: Int { 5 }

    var timeZoneIdentifier: String {
        switch self {
        case .nasdaq, .nyse: "America/New_York"
        case .xetra: "Europe/Berlin"
        }
    }

    var opening: DateComponents {
        switch self {
        case .nasdaq, .nyse: .init(hour: 9, minute: 30)
        case .xetra: .init(hour: 9, minute: 0)
        }
    }

    var closing: DateComponents {
        switch self {
        case .nasdaq, .nyse: .init(hour: 16, minute: 0)
        case .xetra: .init(hour: 17, minute: 30)
        }
    }

    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: timeZoneIdentifier) ?? .gmt
        return calendar
    }

    func session(onDayOf date: Date) -> Range<Date>? {
        guard !calendar.isDateInWeekend(date) else { return nil }

        let day = calendar.startOfDay(for: date)
        let open = calendar.date(byAdding: opening, to: day)
        let close = calendar.date(byAdding: closing, to: day)
        return open.flatMap { open in close.map { open..<$0 } }
    }
}
