//
//  Position.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct Position: Identifiable, Hashable, Sendable {
    public let symbol: TickerSymbol
    public let quantity: Decimal
    public let price: Money
    public let averageCost: Money
    public let averageLocalCost: Money
    public let costBasis: Money
    public let marketValue: Money
    public let unrealizedGain: Money
    public let unrealizedGainPercent: Decimal
    public let realizedGain: Money
    public let todayGain: Money
    public let currencyEffect: Money
    public let totalReturn: Money
    public let totalReturnPercent: Decimal

    public var id: TickerSymbol { symbol }

    public var isOpen: Bool { quantity > 0 }

    public init(
        symbol: TickerSymbol,
        quantity: Decimal,
        price: Money,
        averageCost: Money,
        averageLocalCost: Money,
        costBasis: Money,
        marketValue: Money,
        unrealizedGain: Money,
        unrealizedGainPercent: Decimal,
        realizedGain: Money,
        todayGain: Money,
        currencyEffect: Money,
        totalReturn: Money,
        totalReturnPercent: Decimal
    ) {
        self.symbol = symbol
        self.quantity = quantity
        self.price = price
        self.averageCost = averageCost
        self.averageLocalCost = averageLocalCost
        self.costBasis = costBasis
        self.marketValue = marketValue
        self.unrealizedGain = unrealizedGain
        self.unrealizedGainPercent = unrealizedGainPercent
        self.realizedGain = realizedGain
        self.todayGain = todayGain
        self.currencyEffect = currencyEffect
        self.totalReturn = totalReturn
        self.totalReturnPercent = totalReturnPercent
    }
}

extension Position {
    init(_ dto: PositionDTO) throws(BrokerageError) {
        try self.init(
            symbol: TickerSymbol(rawValue: dto.symbol),
            quantity: dto.quantity,
            price: dto.price.money(),
            averageCost: dto.averageCost.money(),
            averageLocalCost: dto.averageLocalCost.money(),
            costBasis: dto.costBasis.money(),
            marketValue: dto.marketValue.money(),
            unrealizedGain: dto.unrealizedGain.money(),
            unrealizedGainPercent: dto.unrealizedGainPercent,
            realizedGain: dto.realizedGain.money(),
            todayGain: dto.todayGain.money(),
            currencyEffect: dto.currencyEffect.money(),
            totalReturn: dto.totalReturn.money(),
            totalReturnPercent: dto.totalReturnPercent
        )
    }
}
