//
//  PriceHistoryChange.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension PriceHistory {
    func change(to price: Decimal) -> PriceChange? {
        guard let baseline, baseline != 0 else { return nil }

        return PriceChange(start: Money(baseline, currency), end: Money(price, currency))
    }
}
