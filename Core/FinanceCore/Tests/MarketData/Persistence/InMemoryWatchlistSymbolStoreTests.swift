//
//  InMemoryWatchlistSymbolStoreTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

@MainActor
struct InMemoryWatchlistSymbolStoreTests {
    @Test func saveThenReplacesSymbols() {
        // Given
        let store = InMemoryWatchlistSymbolStore(symbols: ["AAPL"])

        // When
        store.save(["AAPL", "SAP"])

        // Then
        #expect(store.symbols == ["AAPL", "SAP"])
    }
}
