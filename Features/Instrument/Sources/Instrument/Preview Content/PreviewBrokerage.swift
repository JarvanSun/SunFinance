//
//  PreviewBrokerage.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

struct PreviewBrokerage: PositionProviding, OrderProviding {
    let isHolding: Bool

    func portfolio() async throws(BrokerageError) -> Portfolio {
        guard isHolding else { return Portfolio(open: [], closed: []) }

        return .init(open: [.dummy], closed: [])
    }

    func orders(
        _ filter: OrderListFilter,
        symbol: TickerSymbol?,
        cursor: String?
    ) async throws(BrokerageError) -> Page<Order> {
        let order: Order =
            switch filter {
            case .open: .dummyOpen
            case .past: .dummyPast
            }
        return .init(elements: isHolding ? [order] : [], nextCursor: nil)
    }
}
#endif
