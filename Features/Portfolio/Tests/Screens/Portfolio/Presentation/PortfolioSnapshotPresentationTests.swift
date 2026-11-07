//
//  PortfolioSnapshotPresentationTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Testing

@testable import Portfolio

struct PortfolioSnapshotPresentationTests {
    @Test func metricsThenShowTodayTotalReturnInvestedAndCash() {
        // When
        let metrics = PortfolioSnapshot(account: sampleAccount, portfolio: samplePortfolio).metrics

        // Then
        #expect(metrics.map(\.id) == ["today", "totalReturn", "invested", "cash"])
        #expect(metrics.map(\.trend) == [.gain, .gain, nil, nil])
    }
}
