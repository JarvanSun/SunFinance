//
//  AppConfigurationDummy.swift
//  SunFinanceTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

@testable import SunFinance

extension AppConfiguration {
    static func dummy(defaultsSuiteName: String?) -> AppConfiguration {
        .init(
            serverBehavior: .instant,
            defaultWatchlist: ["AAPL"],
            vendorAnalyticsAPIKey: "test-key",
            defaultsSuiteName: defaultsSuiteName,
            mockServerStorageURL: nil
        )
    }
}
