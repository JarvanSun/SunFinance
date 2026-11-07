//
//  BrokerageStub.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct BrokerageStub: PositionProviding, OrderProviding {
    var portfolio = Portfolio(open: [], closed: [])
    var openOrders: [Order] = []
    var pastOrders: [Order] = []
    var failure: BrokerageError?

    func portfolio() async throws(BrokerageError) -> Portfolio {
        if let failure { throw failure }
        return portfolio
    }

    func orders(
        _ filter: OrderListFilter,
        symbol: TickerSymbol?,
        cursor: String?
    ) async throws(BrokerageError) -> Page<Order> {
        if let failure { throw failure }
        let matching = (filter == .open ? openOrders : pastOrders).filter { order in
            symbol.map { $0 == order.draft.symbol } ?? true
        }
        let start = cursor.flatMap(Int.init) ?? 0
        let end = min(start + pageSize, matching.count)
        return .init(
            elements: Array(matching[start..<end]),
            nextCursor: end < matching.count ? String(end) : nil
        )
    }
}

private extension BrokerageStub {
    var pageSize: Int { 2 }
}
