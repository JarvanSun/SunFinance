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
        // Given / When
        let snapshot = PortfolioSnapshot(account: Account.dummy, portfolio: Portfolio.dummy)

        // Then
        #expect(snapshot.totalReturn == Money(180, .eur))
        #expect(snapshot.hasOpenPositions)
    }

    @Test func hasOpenPositionsWhenEverythingIsSoldThenIsFalse() {
        // Given / When
        let snapshot = PortfolioSnapshot(
            account: Account.dummy,
            portfolio: Portfolio(open: [], closed: Portfolio.dummy.closed)
        )

        // Then
        #expect(!snapshot.hasOpenPositions)
        #expect(snapshot.totalReturn == Money(30, .eur))
    }
}
