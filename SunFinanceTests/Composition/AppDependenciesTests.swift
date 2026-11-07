//
//  AppDependenciesTests.swift
//  SunFinanceTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import SunFinance

struct AppDependenciesTests {
    @Test func initThenStartsWithoutAnalyticsConsent() throws {
        // Given
        let defaults = try #require(UserDefaults(suiteName: #function))
        defer { defaults.removePersistentDomain(forName: #function) }

        // When
        _ = AppDependencies(configuration: makeConfiguration(suiteName: #function)).watchlist()

        // Then
        let consent = UserDefaultsAnalyticsConsent(defaults: defaults)
        #expect(!consent.isAnalyticsConsentGranted)
    }

    @Test func initThenLeavesTheDefaultWatchlistUnsavedUntilItChanges() throws {
        // Given
        let defaults = try #require(UserDefaults(suiteName: #function))
        defer { defaults.removePersistentDomain(forName: #function) }

        // When
        _ = AppDependencies(configuration: makeConfiguration(suiteName: #function)).watchlist()

        // Then
        let store = UserDefaultsWatchlistSymbolStore(defaults: defaults, defaultSymbols: [])
        #expect(store.symbols.isEmpty)
    }
}

private extension AppDependenciesTests {
    func makeConfiguration(suiteName: String) -> AppConfiguration {
        AppConfiguration(
            serverBehavior: .instant,
            defaultWatchlist: ["AAPL"],
            vendorAnalyticsAPIKey: "test-key",
            defaultsSuiteName: suiteName,
            mockServerStorageURL: nil
        )
    }
}
