//
//  TickerSymbolTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct TickerSymbolTests {
    @Test func initWhenRawValueIsLowercaseThenStoresUppercase() {
        // Given
        let rawValue = "aapl"

        // When
        let symbol = TickerSymbol(rawValue: rawValue)

        // Then
        #expect(symbol.rawValue == "AAPL")
    }

    @Test func sortedThenOrdersAlphabetically() {
        // Given
        let symbols: [TickerSymbol] = ["SAP", "AAPL", "MSFT"]

        // When
        let sortedSymbols = symbols.sorted()

        // Then
        #expect(sortedSymbols == ["AAPL", "MSFT", "SAP"])
    }
}
