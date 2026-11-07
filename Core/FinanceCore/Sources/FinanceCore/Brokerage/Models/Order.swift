//
//  Order.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct Order: Identifiable, Hashable, Sendable {
    public let id: String
    public let draft: OrderDraft
    public let quantity: Decimal
    public let currency: CurrencyCode
    public let status: OrderStatus
    public let createdAt: Date
    public let fill: OrderFill?

    public init(
        id: String,
        draft: OrderDraft,
        quantity: Decimal,
        currency: CurrencyCode,
        status: OrderStatus,
        createdAt: Date,
        fill: OrderFill?
    ) {
        self.id = id
        self.draft = draft
        self.quantity = quantity
        self.currency = currency
        self.status = status
        self.createdAt = createdAt
        self.fill = fill
    }
}

extension Order {
    init(_ dto: OrderDTO) throws(BrokerageError) {
        guard
            let status = OrderStatus(code: dto.status, rejection: dto.rejection),
            let currency = CurrencyCode(rawValue: dto.currency)
        else { throw .decoding }

        try self.init(
            id: dto.id,
            draft: OrderDraft(dto.draft),
            quantity: dto.quantity,
            currency: currency,
            status: status,
            createdAt: dto.createdAt,
            fill: dto.fill.map { dto throws(BrokerageError) in try OrderFill(dto) }
        )
    }
}
