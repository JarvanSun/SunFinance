//
//  AppConfigurationDummyTests.swift
//  SunFinanceTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import SunFinance

struct AppConfigurationDummyTests {
    @Test func dummyThenStartsWithAWatchlistAndStoresTheAccount() {
        // Given / When
        let configuration = AppConfiguration.dummy

        // Then
        #expect(!configuration.defaultWatchlist.isEmpty)
        #expect(configuration.mockServerStorageURL != nil)
        #expect(configuration.defaultsSuiteName == nil)
    }
}
