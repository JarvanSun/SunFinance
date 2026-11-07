//
//  PortfolioChange.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

enum PortfolioChange: Equatable {
    case pending
    case known(Money, percent: Decimal)

    init(from start: Money, to end: Money) {
        let change = end.amount - start.amount
        let percent = start.amount == 0 ? 0 : change / start.amount * 100
        self = .known(Money(change, end.currency), percent: percent)
    }
}
