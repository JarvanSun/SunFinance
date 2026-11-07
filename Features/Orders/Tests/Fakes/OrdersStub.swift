//
//  OrdersStub.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Synchronization

final class OrdersStub: OrderProviding, OrderCancelling {
    struct State {
        var pages: [OrderListFilter: [String?: Page<Order>]] = [:]
        var failure: BrokerageError?
        var failingCursor: String?
        var delay = Duration.zero
        var delays: [Duration] = []
        var cancelResult: Result<OrderStatus, BrokerageError> = .success(.cancelled)
        var requests = 0
    }

    private let state = Mutex(State())

    var requests: Int {
        state.withLock(\.requests)
    }

    func update(_ change: (inout State) -> Void) {
        state.withLock { state in change(&state) }
    }

    func orders(
        _ filter: OrderListFilter,
        symbol: TickerSymbol?,
        cursor: String?
    ) async throws(BrokerageError) -> Page<Order> {
        let delay = state.withLock { state in
            state.requests += 1
            return state.delays.isEmpty ? state.delay : state.delays.removeFirst()
        }
        try? await Task.sleep(for: delay)
        let (page, failure) = state.withLock { state in
            let fails = state.failingCursor != nil && state.failingCursor == cursor
            return (state.pages[filter]?[cursor], fails ? .offline : state.failure)
        }
        if let failure { throw failure }
        return page ?? Page(elements: [], nextCursor: nil)
    }

    func cancel(orderID: Order.ID) async throws(BrokerageError) -> Order {
        let status = try state.withLock(\.cancelResult).get()
        return .make(orderID, status: status)
    }
}
