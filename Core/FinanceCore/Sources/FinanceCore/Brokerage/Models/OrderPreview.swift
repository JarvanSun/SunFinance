//
//  OrderPreview.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct OrderPreview: Hashable, Sendable {
    public let quantity: Decimal
    public let price: Money
    public let exchangeRate: Decimal
    public let fee: Money
    public let total: Money
    public let cashAfter: Money
    public let rejection: OrderRejection?

    public init(
        quantity: Decimal,
        price: Money,
        exchangeRate: Decimal,
        fee: Money,
        total: Money,
        cashAfter: Money,
        rejection: OrderRejection?
    ) {
        self.quantity = quantity
        self.price = price
        self.exchangeRate = exchangeRate
        self.fee = fee
        self.total = total
        self.cashAfter = cashAfter
        self.rejection = rejection
    }
}

extension OrderPreview {
    init(_ dto: PreviewOrderResponseDTO) throws(BrokerageError) {
        try self.init(
            quantity: dto.quantity,
            price: dto.price.money(),
            exchangeRate: dto.exchangeRate,
            fee: dto.fee.money(),
            total: dto.total.money(),
            cashAfter: dto.cashAfter.money(),
            rejection: dto.rejection.flatMap(OrderRejection.init(rawValue:))
        )
    }
}
