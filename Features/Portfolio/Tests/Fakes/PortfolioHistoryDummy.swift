//
//  PortfolioHistoryDummy.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension PortfolioHistory {
    nonisolated static var dummy: PortfolioHistory {
        .init(
            range: .month,
            points: [
                .init(date: Date(timeIntervalSince1970: 0), value: Money(3_000, .eur)),
                .init(date: Date(timeIntervalSince1970: 100), value: Money(3_300, .eur)),
                .init(date: Date(timeIntervalSince1970: 200), value: Money(4_000, .eur)),
            ]
        )
    }
}
