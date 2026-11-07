//
//  AccountDummy.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension Account {
    nonisolated static var dummy: Account {
        .init(
            cash: Money(1_000, .eur),
            buyingPower: Money(1_000, .eur),
            positionsValue: Money(3_000, .eur),
            total: Money(4_000, .eur),
            todayGain: Money(100, .eur)
        )
    }
}
