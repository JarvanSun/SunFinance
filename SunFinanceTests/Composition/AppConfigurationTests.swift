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
        let configuration = AppConfiguration.dummy(defaultsSuiteName: nil)

        // Then
        #expect(configuration.defaults == .standard)
    }

    @Test func defaultsWithSuiteNameThenAreThatSuite() throws {
        // Given
        let suiteName = #function
        let configuration = AppConfiguration.dummy(defaultsSuiteName: suiteName)
        defer { UserDefaults.standard.removePersistentDomain(forName: suiteName) }

        // When
        configuration.defaults.set(true, forKey: suiteName)

        // Then
        let suite = try #require(UserDefaults(suiteName: suiteName))
        #expect(suite.bool(forKey: suiteName))
        #expect(configuration.defaults != .standard)
    }
}
