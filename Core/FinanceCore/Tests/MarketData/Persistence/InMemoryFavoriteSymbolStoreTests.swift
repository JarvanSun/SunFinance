//
//  InMemoryFavoriteSymbolStoreTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

@MainActor
struct InMemoryFavoriteSymbolStoreTests {
    @Test func saveThenReplacesFavoriteSymbols() {
        // Given
        let store = InMemoryFavoriteSymbolStore(favoriteSymbols: ["AAPL"])

        // When
        store.save(["SAP"])

        // Then
        #expect(store.favoriteSymbols == ["SAP"])
    }
}
