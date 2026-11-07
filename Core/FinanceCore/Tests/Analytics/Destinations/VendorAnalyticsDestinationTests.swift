//
//  VendorAnalyticsDestinationTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing
import VendorAnalyticsSDK

@testable import FinanceCore

@MainActor
struct VendorAnalyticsDestinationTests {
    @Test func sendWhenConsentIsGrantedThenLogsVendorEvent() {
        // Given
        let vendor = makeConfiguredVendor()
        let destination = VendorAnalyticsDestination(vendor: vendor)
        destination.applyConsent(true)
        let event = TrackedEvent(
            name: .init("watchlist_viewed"),
            parameters: [.resultCount: .integer(3)]
        )

        // When
        destination.send(event)

        // Then
        let expected = VendorLoggedEvent(name: "watchlist_viewed", parameterNames: ["result_count"])
        #expect(vendor.loggedEvents == [expected])
    }

    @Test func sendWhenConsentIsRevokedThenVendorLogsNothing() {
        // Given
        let vendor = makeConfiguredVendor()
        let destination = VendorAnalyticsDestination(vendor: vendor)
        destination.applyConsent(false)

        // When
        destination.send(TrackedEvent(name: .init("watchlist_viewed"), parameters: [:]))

        // Then
        #expect(vendor.loggedEvents.isEmpty)
    }
}

private extension VendorAnalyticsDestinationTests {
    func makeConfiguredVendor() -> VendorAnalytics {
        let vendor = VendorAnalytics()
        vendor.configure(apiKey: "test-key")
        return vendor
    }
}
