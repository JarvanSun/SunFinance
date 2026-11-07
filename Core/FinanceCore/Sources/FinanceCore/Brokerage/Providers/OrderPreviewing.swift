//
//  OrderPreviewing.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public protocol OrderPreviewing: Sendable {
    func preview(_ draft: OrderDraft) async throws(BrokerageError) -> OrderPreview
}
