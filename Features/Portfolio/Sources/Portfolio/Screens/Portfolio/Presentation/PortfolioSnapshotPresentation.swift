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
            Metric(
                id: "today",
                label: PortfolioText.today,
                value: account.todayGain.formattedSigned(),
                trend: GainTrend(account.todayGain.amount)
            ),
            Metric(
                id: "totalReturn",
                label: PortfolioText.totalReturn,
                value: totalReturn.formattedSigned(),
                trend: GainTrend(totalReturn.amount)
            ),
            Metric(
                id: "invested",
                label: PortfolioText.invested,
                value: account.positionsValue.formatted()
            ),
            Metric(id: "cash", label: PortfolioText.cash, value: account.cash.formatted()),
        ]
    }
}
