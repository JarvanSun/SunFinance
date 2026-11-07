//
//  PortfolioAllocationTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import SwiftUI
import Testing

@testable import Portfolio

struct PortfolioAllocationTests {
    @Test func slicesThenListHoldingsThenNeutralCash() {
        // Given / When
        let slices = makeAllocation().slices

        // Then
        #expect(slices.map(\.id) == ["SAP", "AAPL", "cash"])
        #expect(slices.map(\.tone) == [.holding, .holding, .neutral])
        #expect(slices.map(\.value) == [2_000, 1_000, 1_000])
    }

    @Test(arguments: [
        (String?.some("SAP"), TickerSymbol?.some("SAP")),
        (.some("cash"), nil),
        (nil, nil),
    ])
    func symbolThenIsNilForCash(sliceID: String?, expected: TickerSymbol?) {
        #expect(makeAllocation().symbol(forSlice: sliceID) == expected)
    }

    @Test func centerWhenNothingIsSelectedThenCountsThePositions() {
        #expect(makeAllocation().centerValue(for: nil) == "2")
    }

    @Test func centerWhenASliceIsSelectedThenShowsItsShare() {
        // Given
        let allocation = makeAllocation()

        // When
        let value = allocation.centerValue(for: allocation.slices[0])

        // Then
        #expect(value == 0.5.formatted(.percent.precision(.fractionLength(0))))
    }

    @Test func swatchWhenTheSymbolIsNotHeldThenIsClear() {
        // Given
        let allocation = makeAllocation()

        // Then
        #expect(allocation.swatch(for: "TSLA") == .clear)
        #expect(allocation.swatch(for: "SAP") != .clear)
    }

    @Test func highlightThenTintsOnlyTheSelectedRow() {
        // Given
        let allocation = makeAllocation()

        // Then
        #expect(allocation.highlight(for: "SAP", selection: "AAPL") == .clear)
        #expect(allocation.highlight(for: "SAP", selection: "SAP") != .clear)
    }

    @Test(arguments: [
        (Portfolio.dummy, "portfolio.allocation.summary %@ %@"),
        (Portfolio(open: [], closed: []), "portfolio.allocation.summary.cashOnly"),
    ])
    func contentThenReadsTheLargestPositionOrCashOnly(portfolio: Portfolio, key: String) {
        // Given / When
        let accessibility = PortfolioAllocation(account: Account.dummy, portfolio: portfolio)
            .content
            .accessibility

        // Then
        #expect(accessibility?.summary.key == key)
        #expect(accessibility?.title.key == "portfolio.allocation.title")
    }
}

private extension PortfolioAllocationTests {
    func makeAllocation() -> PortfolioAllocation {
        .init(account: Account.dummy, portfolio: Portfolio.dummy)
    }
}
