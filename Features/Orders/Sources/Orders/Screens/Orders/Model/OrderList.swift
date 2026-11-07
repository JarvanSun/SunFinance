//
//  OrderList.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct OrderList: Equatable {
    enum Phase: Equatable {
        case idle
        case loading
        case loaded
        case failed(OrdersIssue)
    }

    var orders: [Order] = []
    var nextCursor: String?
    var phase = Phase.idle

    var hasMore: Bool {
        nextCursor != nil
    }

    var footer: OrdersFooter? {
        switch (phase, orders.isEmpty, hasMore) {
        case (_, true, _):
            nil
        case (.failed(let issue), false, _):
            .failed(issue)
        case (.idle, false, true), (.loading, false, true), (.loaded, false, true):
            .loadingMore
        case (.idle, false, false), (.loading, false, false), (.loaded, false, false):
            nil
        }
    }

    func days(calendar: Calendar, now: Date) -> [OrderDay] {
        var days: [OrderDay] = []
        for order in orders {
            let day = calendar.startOfDay(for: order.createdAt)
            switch days.last {
            case .some(let last) where last.day == day:
                days[days.count - 1] = OrderDay(
                    day: day,
                    heading: last.heading,
                    orders: last.orders + [order]
                )
            case .some, nil:
                let heading = OrderDayHeading(day: day, calendar: calendar, now: now)
                days.append(OrderDay(day: day, heading: heading, orders: [order]))
            }
        }
        return days
    }
}
