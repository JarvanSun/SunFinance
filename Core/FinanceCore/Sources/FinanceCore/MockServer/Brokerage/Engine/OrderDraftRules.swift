//
//  OrderDraftRules.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension OrderDraft {
    func estimatedPrice(marketPrice: Decimal) -> Decimal {
        switch (execution, trigger) {
        case (.limit(let limit), _): limit
        case (.market, .priceAtOrAbove(let level)), (.market, .priceAtOrBelow(let level)): level
        case (.market, .immediately), (.market, .at): marketPrice
        }
    }

    func quantity(at pricePerShareInEuros: Decimal, fee: Decimal, scale: Int) -> Decimal {
        switch amount {
        case .shares(let shares):
            return shares
        case .euros(let euros):
            guard pricePerShareInEuros > 0 else { return 0 }

            var raw = max(euros - fee, 0) / pricePerShareInEuros
            var rounded = Decimal()
            NSDecimalRound(&rounded, &raw, scale, .down)
            return rounded
        }
    }

    func validationIssue(at date: Date, longestValidity: TimeInterval) -> OrderRejection? {
        switch (amount, execution, trigger) {
        case (.shares(let value), _, _) where value <= 0,
            (.euros(let value), _, _) where value <= 0:
            .invalidAmount
        case (_, .limit(let price), _) where price <= 0: .invalidPrice
        case (_, _, .priceAtOrAbove(let price)) where price <= 0,
            (_, _, .priceAtOrBelow(let price)) where price <= 0:
            .invalidPrice
        case (_, _, .at(let time))
        where time <= date || time > date.addingTimeInterval(longestValidity):
            .invalidSchedule
        default: nil
        }
    }

    func isTriggered(at moment: Date, price: Decimal) -> Bool {
        switch trigger {
        case .immediately: true
        case .priceAtOrAbove(let level): price >= level
        case .priceAtOrBelow(let level): price <= level
        case .at(let time): moment >= time
        }
    }
}
