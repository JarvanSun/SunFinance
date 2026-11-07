//
//  PortfolioSnapshotPresentation.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension PortfolioSnapshot {
    var metrics: [Metric] {
        [
            .init(
                id: "today",
                label: .init("portfolio.metric.today", bundle: .module),
                value: account.todayGain.formattedSigned(),
                trend: GainTrend(account.todayGain.amount)
            ),
            .init(
                id: "totalReturn",
                label: .init("portfolio.metric.totalReturn", bundle: .module),
                value: totalReturn.formattedSigned(),
                trend: GainTrend(totalReturn.amount)
            ),
            .init(
                id: "invested",
                label: .init("portfolio.metric.invested", bundle: .module),
                value: account.positionsValue.formatted()
            ),
            .init(
                id: "cash",
                label: .init("portfolio.allocation.cash", bundle: .module),
                value: account.cash.formatted()
            ),
        ]
    }
}
