//
//  PositionBookTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct PositionBookTests {
    @Test func holdingsThenAddUpFillsPerSymbolUpToTheMoment() {
        // Given
        let book = PositionBook(fills: [
            .dummy(.buy, 5, at: 100, day: 2),
            .dummy(.buy, 10, at: 100, day: 0),
            .dummy(.buy, 3, at: 50, symbol: "ALV", day: 1),
        ])

        // When
        let holdings = book.holdings(asOf: day(1))

        // Then
        #expect(holdings.map(\.symbol) == ["ALV", "SAP"])
        #expect(holdings.map(\.quantity) == [3, 10])
    }

    @Test func holdingsThenKeepSymbolsSoldCompletely() {
        // Given
        let book = PositionBook(fills: [
            .dummy(.buy, 10, at: 100),
            .dummy(.sell, 10, at: 90, day: 1),
        ])

        // When
        let holding = book.holding(of: "SAP", asOf: day(1))

        // Then
        #expect(holding?.isOpen == false)
        #expect(holding?.realizedGain == -102)
    }

    @Test func holdingWhenSymbolWasNeverTradedThenIsNil() {
        // Given
        let book = PositionBook(fills: [.dummy(.buy, 10, at: 100)])

        // Then
        #expect(book.holding(of: "KO", asOf: day(5)) == nil)
    }

    @Test func fillsThenReturnsOnlyTheSymbolsFillsAfterTheMoment() {
        // Given
        let later = LedgerFill.dummy(.sell, 2, at: 120, day: 2)
        let book = PositionBook(fills: [
            .dummy(.buy, 10, at: 100),
            later,
            .dummy(.buy, 1, at: 50, symbol: "ALV", day: 3),
        ])

        // When
        let fills = book.fills(of: "SAP", after: day(1))

        // Then
        #expect(fills == [later])
    }
}

private extension PositionBookTests {
    func day(_ offset: Double) -> Date {
        .init(timeIntervalSince1970: 1_790_000_000 + offset * 86_400)
    }
}
