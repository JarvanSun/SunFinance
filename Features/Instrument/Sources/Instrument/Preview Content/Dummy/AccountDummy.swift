//
//  AccountDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension Account {
    nonisolated static var dummy: Account {
        .init(
            cash: Money(9_876.54, .eur),
            buyingPower: Money(9_876.54, .eur),
            positionsValue: Money(12_345.67, .eur),
            total: Money(22_222.21, .eur),
            todayGain: Money(84.2, .eur)
        )
    }
}
#endif
