//
//  OrderFill.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct OrderFill: Hashable, Sendable {
    public let date: Date
    public let quantity: Decimal
    public let price: Money
    public let exchangeRate: Decimal
    public let fee: Money
    public let total: Money

    public init(
        date: Date,
        quantity: Decimal,
        price: Money,
        exchangeRate: Decimal,
        fee: Money,
        total: Money
    ) {
        self.date = date
        self.quantity = quantity
        self.price = price
        self.exchangeRate = exchangeRate
        self.fee = fee
        self.total = total
    }
}

extension OrderFill {
    init(_ dto: FillDTO) throws(BrokerageError) {
        try self.init(
            date: dto.date,
            quantity: dto.quantity,
            price: dto.price.money(),
            exchangeRate: dto.exchangeRate,
            fee: dto.fee.money(),
            total: dto.total.money()
        )
    }
}
