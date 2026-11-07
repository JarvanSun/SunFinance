//
//  TradingEvent.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum TradingEvent: AnalyticsEvent, Equatable {
    case ticketOpened(TradeIntent)
    case orderReviewed(OrderDraft)
    case orderPlaced(Order)
    case orderFailed(reason: String)

    var name: AnalyticsEventName {
        switch self {
        case .ticketOpened:
            .init("trading_ticket_opened")
        case .orderReviewed:
            .init("trading_order_reviewed")
        case .orderPlaced:
            .init("trading_order_placed")
        case .orderFailed:
            .init("trading_order_failed")
        }
    }

    var parameters: [AnalyticsParameter: AnalyticsValue] {
        switch self {
        case .ticketOpened(let intent):
            [
                .symbol: .text(intent.symbol.rawValue),
                .side: .text(intent.side.rawValue),
                .source: .text(intent.source.rawValue),
            ]
        case .orderReviewed(let draft):
            describe(draft)
        case .orderPlaced(let order):
            describe(order.draft).merging(
                [
                    .symbol: .text(order.draft.symbol.rawValue),
                    .status: .text(order.status.analyticsValue),
                ]
            ) { current, _ in current }
        case .orderFailed(let reason):
            [.failureReason: .text(reason)]
        }
    }
}

private extension TradingEvent {
    func describe(_ draft: OrderDraft) -> [AnalyticsParameter: AnalyticsValue] {
        [
            .side: .text(draft.side.rawValue),
            .orderType: .text(draft.kind.rawValue),
            .trigger: .text(draft.triggerKind.rawValue),
        ]
    }
}

private extension OrderStatus {
    var analyticsValue: String {
        switch self {
        case .waitingForTrigger:
            "waiting_for_trigger"
        case .waitingForPrice:
            "waiting_for_price"
        case .scheduled:
            "scheduled"
        case .waitingForOpen:
            "waiting_for_open"
        case .filled:
            "filled"
        case .cancelled:
            "cancelled"
        case .expired:
            "expired"
        case .rejected(let rejection):
            "rejected_\(rejection.rawValue)"
        }
    }
}
