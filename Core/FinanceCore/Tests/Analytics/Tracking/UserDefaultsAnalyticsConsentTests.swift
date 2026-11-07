//
//  UserDefaultsAnalyticsConsentTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

@MainActor
struct UserDefaultsAnalyticsConsentTests {
    @Test func initWhenNothingIsStoredThenConsentIsMissing() throws {
        // Given
        let defaults = try #require(UserDefaults(suiteName: #function))
        defer { defaults.removePersistentDomain(forName: #function) }

        // When
        let consent = UserDefaultsAnalyticsConsent(defaults: defaults)

        // Then
        #expect(!consent.isAnalyticsConsentGranted)
    }

    @Test func setConsentThenNewInstanceReadsIt() throws {
        // Given
        let defaults = try #require(UserDefaults(suiteName: #function))
        defer { defaults.removePersistentDomain(forName: #function) }
        let consent = UserDefaultsAnalyticsConsent(defaults: defaults)

        // When
        consent.setConsent(true)

        // Then
        #expect(UserDefaultsAnalyticsConsent(defaults: defaults).isAnalyticsConsentGranted)
    }
}
