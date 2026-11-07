//
//  OrdersQuery.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

struct OrdersQuery: Equatable, Sendable {
    let filter: OrderListFilter
    let symbol: TickerSymbol?
    let cursor: String?

    func matches(_ order: LedgerOrder) -> Bool {
        let matchesFilter = (order.state == .working) == (filter == .open)
        let matchesSymbol = symbol.map { $0 == order.draft.symbol } ?? true
        return matchesFilter && matchesSymbol
    }
}
