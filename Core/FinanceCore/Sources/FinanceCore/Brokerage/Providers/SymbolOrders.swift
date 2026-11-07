//
//  SymbolOrders.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

extension OrderProviding {
    public func allOrders(_ filter: OrderListFilter, for symbol: TickerSymbol)
        async throws(BrokerageError) -> [Order]
    {
        var collected: [Order] = []
        var cursor: String?
        repeat {
            let page = try await orders(filter, symbol: symbol, cursor: cursor)
            collected += page.elements
            cursor = page.nextCursor
        } while cursor != nil
        return collected
    }
}
