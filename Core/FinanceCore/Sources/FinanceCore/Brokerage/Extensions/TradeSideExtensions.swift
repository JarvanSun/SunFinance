//
//  TradeSideExtensions.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension TradeSide {
    func cashEffect(gross: Decimal, fee: Decimal) -> Decimal {
        switch self {
        case .buy:
            -(gross + fee)
        case .sell:
            gross - fee
        }
    }

    func total(ofCashEffect cashEffect: Decimal) -> Decimal {
        switch self {
        case .buy:
            -cashEffect
        case .sell:
            cashEffect
        }
    }
}
