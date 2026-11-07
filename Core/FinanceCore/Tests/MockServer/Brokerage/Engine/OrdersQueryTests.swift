//
//  OrdersQueryTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct OrdersQueryTests {
    @Test(arguments: [
        (OrderListFilter.open, LedgerOrder.State.working, true),
        (.open, .filled, false),
        (.past, .working, false),
        (.past, .cancelled, true),
    ])
    func matchesWhenNoSymbolIsGivenThenFollowsTheFilter(
        filter: OrderListFilter,
        state: LedgerOrder.State,
        expected: Bool
    ) {
        // Given
        let query = OrdersQuery(filter: filter, symbol: nil, cursor: nil)

        // Then
        #expect(query.matches(order(state: state, symbol: "SAP")) == expected)
    }

    @Test(arguments: [(TickerSymbol(rawValue: "SAP"), true), ("AAPL", false)])
    func matchesWhenASymbolIsGivenThenKeepsOnlyItsOrders(symbol: TickerSymbol, expected: Bool) {
        // Given
        let query = OrdersQuery(filter: .open, symbol: symbol, cursor: nil)

        // Then
        #expect(query.matches(order(state: .working, symbol: "SAP")) == expected)
    }
}

private extension OrdersQueryTests {
    func order(state: LedgerOrder.State, symbol: TickerSymbol) -> LedgerOrder {
        LedgerOrder(
            id: "order-1",
            draft: .init(symbol: symbol),
            quantity: 1,
            createdAt: Date(timeIntervalSince1970: 100),
            state: state,
            releasedAt: nil,
            rejection: nil,
            fillID: nil
        )
    }
}
