//
//  OrdersEvent.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum OrdersEvent: AnalyticsEvent, Equatable {
    case viewed(openCount: Int)
    case cancelled(OrderDraft)

    var name: AnalyticsEventName {
        switch self {
        case .viewed: .init("orders_viewed")
        case .cancelled: .init("trading_order_cancelled")
        }
    }

    var parameters: [AnalyticsParameter: AnalyticsValue] {
        switch self {
        case .viewed(let count): [.openCount: .integer(count)]
        case .cancelled(let draft):
            [.orderType: .text(draft.kind.rawValue), .trigger: .text(draft.triggerKind.rawValue)]
        }
    }
}
