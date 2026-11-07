//
//  UserDefaultsWatchlistSymbolStoreTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

@MainActor
struct UserDefaultsWatchlistSymbolStoreTests {
    @Test func initWhenNothingIsSavedThenStartsFromDefaultSymbols() throws {
        // Given
        let defaults = try #require(UserDefaults(suiteName: #function))
        defer { defaults.removePersistentDomain(forName: #function) }

        // When
        let store = UserDefaultsWatchlistSymbolStore(defaults: defaults, defaultSymbols: ["AAPL"])

        // Then
        #expect(store.symbols == ["AAPL"])
    }

    @Test func saveThenNewStoreReadsSavedSymbolsInOrder() throws {
        // Given
        let defaults = try #require(UserDefaults(suiteName: #function))
        defer { defaults.removePersistentDomain(forName: #function) }
        let store = UserDefaultsWatchlistSymbolStore(defaults: defaults, defaultSymbols: ["AAPL"])

        // When
        store.save(["SAP", "AAPL", "TSLA"])

        // Then
        let reloadedStore = UserDefaultsWatchlistSymbolStore(defaults: defaults, defaultSymbols: [])
        #expect(reloadedStore.symbols == ["SAP", "AAPL", "TSLA"])
    }
}
