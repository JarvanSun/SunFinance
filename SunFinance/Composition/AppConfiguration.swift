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
}
