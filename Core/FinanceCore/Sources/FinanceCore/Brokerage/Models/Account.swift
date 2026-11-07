//
//  Account.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct Account: Hashable, Sendable {
    public let cash: Money
    public let buyingPower: Money
    public let positionsValue: Money
    public let total: Money
    public let todayGain: Money

    public init(
        cash: Money,
        buyingPower: Money,
        positionsValue: Money,
        total: Money,
        todayGain: Money
    ) {
        self.cash = cash
        self.buyingPower = buyingPower
        self.positionsValue = positionsValue
        self.total = total
        self.todayGain = todayGain
    }
}

extension Account {
    init(_ dto: AccountResponseDTO) throws(BrokerageError) {
        try self.init(
            cash: dto.cash.money(),
            buyingPower: dto.buyingPower.money(),
            positionsValue: dto.positionsValue.money(),
            total: dto.total.money(),
            todayGain: dto.todayGain.money()
        )
    }
}
