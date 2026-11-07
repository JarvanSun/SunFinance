//
//  OrderListTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Orders

struct OrderListTests {
    @Test(arguments: [
        (OrderList(orders: [], nextCursor: "1", phase: .loaded), OrdersFooter?.none),
        (OrderList(orders: [.dummy("1")], nextCursor: "1", phase: .loaded), .loadingMore),
        (OrderList(orders: [.dummy("1")], nextCursor: "1", phase: .loading), .loadingMore),
        (OrderList(orders: [.dummy("1")], nextCursor: nil, phase: .loaded), nil),
        (
            OrderList(orders: [.dummy("1")], nextCursor: "1", phase: .failed(.offline)),
            .failed(.offline)
        ),
    ])
    func footerThenSpinsOrOffersARetry(list: OrderList, expected: OrdersFooter?) {
        #expect(list.footer == expected)
    }

    @Test func daysThenGroupOrdersByCalendarDayNewestFirst() {
        // Given
        let calendar = utcCalendar
        let now = Date(timeIntervalSince1970: 2 * 86_400 + 3_600)
        let list = OrderList(
            orders: [
                .dummy("1", createdAt: Date(timeIntervalSince1970: 2 * 86_400 + 60)),
                .dummy("2", createdAt: Date(timeIntervalSince1970: 2 * 86_400)),
                .dummy("3", createdAt: Date(timeIntervalSince1970: 86_400 + 60)),
                .dummy("4", createdAt: Date(timeIntervalSince1970: 60)),
            ]
        )

        // When
        let days = list.days(calendar: calendar, now: now)

        // Then
        #expect(days.map { $0.orders.map(\.id) } == [["1", "2"], ["3"], ["4"]])
        let earlier = OrderDayHeading.date(.init(timeIntervalSince1970: 0))
        #expect(days.map(\.heading) == [.today, .yesterday, earlier])
    }
}

private extension OrderListTests {
    var utcCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }
}
