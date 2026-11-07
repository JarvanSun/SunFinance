//
//  OrderProviding.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public protocol OrderProviding: Sendable {
    func orders(
        _ filter: OrderListFilter,
        symbol: TickerSymbol?,
        cursor: String?
    ) async throws(BrokerageError) -> Page<Order>
}
