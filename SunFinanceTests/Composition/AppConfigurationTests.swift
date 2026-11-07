//
//  AppConfigurationTests.swift
//  SunFinanceTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import SunFinance

struct AppConfigurationTests {
    @Test func defaultsWithoutSuiteNameThenAreStandard() {
        // Given
        let configuration = makeConfiguration(defaultsSuiteName: nil)

        // Then
        #expect(configuration.defaults == .standard)
    }

    @Test func defaultsWithSuiteNameThenAreThatSuite() throws {
        // Given
        let suiteName = #function
        let configuration = makeConfiguration(defaultsSuiteName: suiteName)
        defer { UserDefaults.standard.removePersistentDomain(forName: suiteName) }

        // When
        configuration.defaults.set(true, forKey: suiteName)

        // Then
        let suite = try #require(UserDefaults(suiteName: suiteName))
        #expect(suite.bool(forKey: suiteName))
        #expect(configuration.defaults != .standard)
    }

    @Test func initThenStartsWithAWatchlistAndStoresTheAccount() {
        // When
        let configuration = AppConfiguration()

        // Then
        #expect(!configuration.defaultWatchlist.isEmpty)
        #expect(configuration.mockServerStorageURL != nil)
        #expect(configuration.defaultsSuiteName == nil)
    }
}

private extension AppConfigurationTests {
    func makeConfiguration(defaultsSuiteName: String?) -> AppConfiguration {
        AppConfiguration(
            serverBehavior: .instant,
            defaultWatchlist: ["AAPL"],
            vendorAnalyticsAPIKey: "test-key",
            defaultsSuiteName: defaultsSuiteName,
            mockServerStorageURL: nil
        )
    }
}
