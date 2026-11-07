//
//  OrderDraftKind.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

extension OrderDraft {
    public var kind: OrderKind {
        switch (execution, trigger) {
        case (.market, .priceAtOrAbove), (.market, .priceAtOrBelow): .stop
        case (.limit, .priceAtOrAbove), (.limit, .priceAtOrBelow): .stopLimit
        case (.market, .immediately), (.market, .at): .market
        case (.limit, .immediately), (.limit, .at): .limit
        }
    }

    public var triggerKind: OrderTriggerKind {
        switch trigger {
        case .immediately: .now
        case .priceAtOrAbove, .priceAtOrBelow: .price
        case .at: .time
        }
    }
}
