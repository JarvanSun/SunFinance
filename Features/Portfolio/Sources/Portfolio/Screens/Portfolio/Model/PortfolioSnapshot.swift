//
//  PortfolioSnapshot.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct PortfolioSnapshot: Equatable {
    let account: Account
    let portfolio: Portfolio
    let allocation: PortfolioAllocation

    init(account: Account, portfolio: Portfolio) {
        self.account = account
        self.portfolio = portfolio
        allocation = PortfolioAllocation(account: account, portfolio: portfolio)
    }

    var totalReturn: Money {
        let positions = portfolio.open + portfolio.closed
        return Money(
            positions.reduce(Decimal.zero) { $0 + $1.totalReturn.amount },
            account.total.currency
        )
    }

    var hasOpenPositions: Bool {
        !portfolio.open.isEmpty
    }
}
