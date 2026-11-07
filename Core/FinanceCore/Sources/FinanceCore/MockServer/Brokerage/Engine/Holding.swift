//
//  Holding.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct Holding: Equatable, Sendable {
    let symbol: TickerSymbol
    let currency: CurrencyCode
    private(set) var quantity: Decimal = 0
    private(set) var costBasis: Decimal = 0
    private(set) var costBasisWithoutFees: Decimal = 0
    private(set) var localCostBasis: Decimal = 0
    private(set) var realizedGain: Decimal = 0
    private(set) var invested: Decimal = 0

    var isOpen: Bool {
        quantity > 0
    }

    var averageCost: Decimal {
        quantity > 0 ? costBasis / quantity : 0
    }

    var averageLocalCost: Decimal {
        quantity > 0 ? localCostBasis / quantity : 0
    }

    var averageRate: Decimal {
        localCostBasis > 0 ? costBasisWithoutFees / localCostBasis : 1
    }

    init(symbol: TickerSymbol, currency: CurrencyCode) {
        self.symbol = symbol
        self.currency = currency
    }

    mutating func apply(_ fill: LedgerFill) {
        switch fill.side {
        case .buy:
            buy(fill)
        case .sell:
            sell(fill)
        }
    }

    private mutating func buy(_ fill: LedgerFill) {
        quantity += fill.quantity
        costBasis += fill.grossInEuros + fill.fee
        costBasisWithoutFees += fill.grossInEuros
        localCostBasis += fill.quantity * fill.price
        invested += fill.grossInEuros + fill.fee
    }

    private mutating func sell(_ fill: LedgerFill) {
        let sold = min(fill.quantity, quantity)
        let share = quantity > 0 ? sold / quantity : 0
        let removedCost = costBasis * share
        realizedGain += fill.grossInEuros - fill.fee - removedCost
        costBasis -= removedCost
        costBasisWithoutFees -= costBasisWithoutFees * share
        localCostBasis -= localCostBasis * share
        quantity -= sold
    }
}
