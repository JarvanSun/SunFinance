//
//  AppConfiguration.swift
//  SunFinance
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct AppConfiguration {
    let serverBehavior: MockServerBehavior
    let defaultWatchlist: [TickerSymbol]
    let vendorAnalyticsAPIKey: String
    let defaultsSuiteName: String?
    let mockServerStorageURL: URL?

    var defaults: UserDefaults {
        defaultsSuiteName.flatMap(UserDefaults.init(suiteName:)) ?? .standard
    }

    init(
        serverBehavior: MockServerBehavior = .realistic,
        defaultWatchlist: [TickerSymbol] = [
            "AAPL",
            "MSFT",
            "NVDA",
            "AMZN",
            "GOOGL",
            "TSLA",
            "ASML",
            "SAP",
            "SIE",
            "ALV",
        ],
        vendorAnalyticsAPIKey: String = "demo-vendor-key",
        defaultsSuiteName: String? = nil,
        mockServerStorageURL: URL? = URL.applicationSupportDirectory.appending(path: "MockServer")
    ) {
        self.serverBehavior = serverBehavior
        self.defaultWatchlist = defaultWatchlist
        self.vendorAnalyticsAPIKey = vendorAnalyticsAPIKey
        self.defaultsSuiteName = defaultsSuiteName
        self.mockServerStorageURL = mockServerStorageURL
    }
}
