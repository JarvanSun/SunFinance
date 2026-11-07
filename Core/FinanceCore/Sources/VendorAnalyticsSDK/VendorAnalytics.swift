//
//  VendorAnalytics.swift
//  VendorAnalyticsSDK
//
//  Created by Jiawen Sun on 2026/11/07.
//

public final class VendorAnalytics {
    public static let shared = VendorAnalytics()

    public private(set) var apiKey: String?
    public private(set) var isOptedOut = true
    public private(set) var loggedEvents: [VendorLoggedEvent] = []

    public init() {}

    public func configure(apiKey: String) {
        self.apiKey = apiKey
    }

    public func setOptOut(_ isOptedOut: Bool) {
        self.isOptedOut = isOptedOut
    }

    public func logEvent(_ name: String, parameters: [String: Any]) {
        guard apiKey != nil, !isOptedOut else { return }

        loggedEvents.append(VendorLoggedEvent(name: name, parameterNames: Set(parameters.keys)))
    }
}
