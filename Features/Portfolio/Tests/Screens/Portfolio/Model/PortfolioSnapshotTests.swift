//
//  PortfolioSnapshotTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Portfolio

struct PortfolioSnapshotTests {
    @Test func totalReturnThenSumsOpenAndClosedPositions() {
        // When
        let snapshot = PortfolioSnapshot(account: sampleAccount, portfolio: samplePortfolio)

        // Then
        #expect(snapshot.totalReturn == Money(180, .eur))
        #expect(snapshot.hasOpenPositions)
    }

    @Test func hasOpenPositionsWhenEverythingIsSoldThenIsFalse() {
        // When
        let snapshot = PortfolioSnapshot(
            account: sampleAccount,
            portfolio: Portfolio(open: [], closed: samplePortfolio.closed)
        )

        // Then
        #expect(!snapshot.hasOpenPositions)
        #expect(snapshot.totalReturn == Money(30, .eur))
    }
}
