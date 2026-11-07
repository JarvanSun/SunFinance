//
//  OrderDayHeading.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

enum OrderDayHeading: Equatable, Sendable {
    case today
    case yesterday
    case date(Date)

    init(day: Date, calendar: Calendar, now: Date) {
        let today = calendar.startOfDay(for: now)
        switch day {
        case today:
            self = .today
        case calendar.date(byAdding: .day, value: -1, to: today):
            self = .yesterday
        default:
            self = .date(day)
        }
    }
}
