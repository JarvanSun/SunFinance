//
//  OrderPlacing.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public protocol OrderPlacing: Sendable {
    func place(_ draft: OrderDraft, idempotencyKey: IdempotencyKey) async throws(BrokerageError)
        -> Order
}
