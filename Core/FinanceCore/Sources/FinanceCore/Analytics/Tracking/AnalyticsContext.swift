//
//  AnalyticsContext.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct AnalyticsContext: Sendable {
    public let appVersion: String
    public let locale: Locale

    public init(appVersion: String, locale: Locale) {
        self.appVersion = appVersion
        self.locale = locale
    }

    var parameters: [AnalyticsParameter: AnalyticsValue] {
        [
            .appVersion: .text(appVersion),
            .locale: .text(locale.identifier),
        ]
    }
}
