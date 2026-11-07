//
//  PortfolioHistoryDummy.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension PortfolioHistory {
    nonisolated static func dummy(range: HistoryRange) -> PortfolioHistory {
        let start = Date(timeIntervalSince1970: 1_791_000_000)
        let points = (0..<120).map { index in
            PortfolioValuePoint(
                date: start.addingTimeInterval(Double(index) * 21_600),
                value: Money(
                    Decimal(20_000 + sin(Double(index) / 9) * 400 + Double(index) * 5),
                    .eur
                )
            )
        }
        return .init(range: range, points: points)
    }
}
#endif
