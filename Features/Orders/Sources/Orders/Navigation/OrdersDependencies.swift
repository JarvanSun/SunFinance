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
    let orderProvider: any OrderProviding
    let canceller: any OrderCancelling
    let tracker: any AnalyticsTracking
    let quoteDetail: FeatureEntry<TickerSymbol>
    let calendar: Calendar
    let now: @Sendable () -> Date

    public init(
        orderProvider: some OrderProviding,
        canceller: some OrderCancelling,
        tracker: some AnalyticsTracking,
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

    func makeViewModel(router: some OrdersRouting) -> OrdersViewModel {
        OrdersViewModel(
            orderProvider: orderProvider,
            router: router,
            tracker: tracker,
            calendar: calendar,
            now: now
        )
    }

    func makeDetailViewModel(
        order: Order,
        router: some OrdersRouting,
        onChange: @escaping (Order) -> Void
    ) -> OrderDetailViewModel {
        OrderDetailViewModel(
            order: order,
            canceller: canceller,
            router: router,
            tracker: tracker,
            onChange: onChange
        )
    }
}
