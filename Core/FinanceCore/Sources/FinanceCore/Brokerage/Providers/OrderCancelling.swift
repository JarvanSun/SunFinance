//
//  OrderCancelling.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public protocol OrderCancelling: Sendable {
    func cancel(orderID: Order.ID) async throws(BrokerageError) -> Order
}
