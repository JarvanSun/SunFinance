//
//  UserDefaultsFavoriteSymbolStoreTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

@MainActor
struct UserDefaultsFavoriteSymbolStoreTests {
    @Test func saveThenNewStoreReadsSavedSymbols() throws {
        // Given
        let defaults = try #require(UserDefaults(suiteName: #function))
        defer { defaults.removePersistentDomain(forName: #function) }
        let store = UserDefaultsFavoriteSymbolStore(defaults: defaults)

        // When
        store.save(["SAP", "AAPL"])

        // Then
        let reloadedStore = UserDefaultsFavoriteSymbolStore(defaults: defaults)
        #expect(reloadedStore.favoriteSymbols == ["SAP", "AAPL"])
    }
}
