//
//  AppConfigurationDummy.swift
//  SunFinance
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension AppConfiguration {
    static var dummy: AppConfiguration {
        .init(
            serverBehavior: .realistic,
            defaultWatchlist: TickerSymbol.dummyWatchlist,
            vendorAnalyticsAPIKey: "demo-vendor-key",
            defaultsSuiteName: nil,
            mockServerStorageURL: URL.applicationSupportDirectory.appending(path: "MockServer")
        )
    }
}
