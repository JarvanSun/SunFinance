//
//  AccountDummy.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension Account {
    nonisolated static var dummy: Account {
        .init(
            cash: Money(10_000, .eur),
            buyingPower: Money(10_000, .eur),
            positionsValue: Money(10_622, .eur),
            total: Money(20_622, .eur),
            todayGain: Money(84.2, .eur)
        )
    }

    nonisolated static var dummyWithoutPositions: Account {
        .init(
            cash: Money(10_000, .eur),
            buyingPower: Money(10_000, .eur),
            positionsValue: Money(0, .eur),
            total: Money(10_000, .eur),
            todayGain: Money(0, .eur)
        )
    }
}
#endif
