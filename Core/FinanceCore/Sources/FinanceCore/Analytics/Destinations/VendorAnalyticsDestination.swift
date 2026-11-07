//
//  VendorAnalyticsDestination.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import VendorAnalyticsSDK

@MainActor
public final class VendorAnalyticsDestination: AnalyticsDestination {
    private let vendor: VendorAnalytics

    public init(apiKey: String) {
        vendor = .shared
        vendor.configure(apiKey: apiKey)
    }

    init(vendor: VendorAnalytics) {
        self.vendor = vendor
    }

    public func send(_ event: TrackedEvent) {
        vendor.logEvent(event.name.rawValue, parameters: vendorParameters(of: event))
    }

    public func applyConsent(_ isGranted: Bool) {
        vendor.setOptOut(!isGranted)
    }
}

private extension VendorAnalyticsDestination {
    func vendorParameters(of event: TrackedEvent) -> [String: Any] {
        let pairs = event.parameters.map { ($0.key.rawValue, vendorValue(of: $0.value)) }
        return Dictionary(uniqueKeysWithValues: pairs)
    }

    func vendorValue(of value: AnalyticsValue) -> Any {
        switch value {
        case .text(let text):
            text
        case .integer(let integer):
            integer
        case .decimal(let decimal):
            NSDecimalNumber(decimal: decimal)
        case .boolean(let boolean):
            boolean
        }
    }
}
