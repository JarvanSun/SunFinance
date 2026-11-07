//
//  UserDefaultsAnalyticsConsent.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

@MainActor
public final class UserDefaultsAnalyticsConsent: AnalyticsConsentProviding {
    private enum StorageKey: String {
        case isConsentGranted = "analytics.isConsentGranted"
    }

    public private(set) var isAnalyticsConsentGranted: Bool

    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        isAnalyticsConsentGranted = defaults.bool(forKey: StorageKey.isConsentGranted.rawValue)
    }

    public func setConsent(_ isGranted: Bool) {
        isAnalyticsConsentGranted = isGranted
        defaults.set(isGranted, forKey: StorageKey.isConsentGranted.rawValue)
    }
}
