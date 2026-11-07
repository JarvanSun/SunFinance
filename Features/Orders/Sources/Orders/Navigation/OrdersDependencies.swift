//
//  OrdersDependencies.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

public struct OrdersDependencies {
    let orderProvider: OrderProviding
    let canceller: OrderCancelling
    let tracker: AnalyticsTracking
    let quoteDetail: FeatureEntry<TickerSymbol>
    let calendar: Calendar
    let now: @Sendable () -> Date

    public init(
        orderProvider: OrderProviding,
        canceller: OrderCancelling,
        tracker: AnalyticsTracking,
        quoteDetail: FeatureEntry<TickerSymbol>,
        calendar: Calendar = .autoupdatingCurrent,
        now: @escaping @Sendable () -> Date = { Date() }
    ) {
        self.orderProvider = orderProvider
        self.canceller = canceller
        self.tracker = tracker
        self.quoteDetail = quoteDetail
        self.calendar = calendar
        self.now = now
    }

    func makeViewModel(router: OrdersRouting) -> OrdersViewModel {
        .init(
            orderProvider: orderProvider,
            router: router,
            tracker: tracker,
            calendar: calendar,
            now: now
        )
    }

    func makeDetailViewModel(
        order: Order,
        router: OrdersRouting,
        onChange: @escaping (Order) -> Void
    ) -> OrderDetailViewModel {
        .init(
            order: order,
            canceller: canceller,
            router: router,
            tracker: tracker,
            onChange: onChange
        )
    }
}
