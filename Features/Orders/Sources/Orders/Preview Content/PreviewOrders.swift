//
//  PreviewOrders.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

struct PreviewOrders: OrderProviding, OrderCancelling {
    var isEmpty = false
    var failure: BrokerageError?
    var delay = Duration.zero

    func orders(
        _ filter: OrderListFilter,
        symbol: TickerSymbol?,
        cursor: String?
    ) async throws(BrokerageError) -> Page<Order> {
        try? await Task.sleep(for: delay)
        if let failure { throw failure }
        let orders =
            isEmpty
            ? [] : PreviewObjectPool.sampleOrders.filter { $0.status.isOpen == (filter == .open) }
        return Page(elements: orders, nextCursor: nil)
    }

    func cancel(orderID: Order.ID) async throws(BrokerageError) -> Order {
        let order =
            PreviewObjectPool.sampleOrders.first { $0.id == orderID }
            ?? PreviewObjectPool.sampleOrders[0]
        return Order(
            id: order.id,
            draft: order.draft,
            quantity: order.quantity,
            currency: order.currency,
            status: .cancelled,
            createdAt: order.createdAt,
            fill: nil
        )
    }
}
#endif
