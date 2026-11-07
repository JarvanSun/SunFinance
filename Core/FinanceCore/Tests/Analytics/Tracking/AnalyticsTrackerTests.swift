//
//  AnalyticsTrackerTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

@MainActor
struct AnalyticsTrackerTests {
    @Test func trackWhenConsentIsMissingThenDropsEvent() {
        // Given
        let destination = AnalyticsDestinationSpy()
        let tracker = makeTracker(isConsentGranted: false, destination: destination)

        // When
        tracker.track(TestEvent.favoriteToggled)

        // Then
        #expect(destination.sentEvents.isEmpty)
    }

    @Test func trackWhenConsentIsGrantedThenForwardsEnrichedEvent() throws {
        // Given
        let destination = AnalyticsDestinationSpy()
        let tracker = makeTracker(isConsentGranted: true, destination: destination)

        // When
        tracker.track(TestEvent.favoriteToggled)

        // Then
        let sentEvent = try #require(destination.sentEvents.first)
        #expect(sentEvent.name == TestEvent.favoriteToggled.name)
        #expect(sentEvent.parameters[.symbol] == .text("AAPL"))
        #expect(sentEvent.parameters[.appVersion] == .text("1.0"))
        #expect(sentEvent.parameters[.locale] == .text("de_DE"))
    }

    @Test func trackWhenEventCarriesPersonalDataThenDropsEvent() {
        // Given
        let destination = AnalyticsDestinationSpy()
        let tracker = makeTracker(isConsentGranted: true, destination: destination)

        // When
        tracker.track(TestEvent.searchWithQuery)

        // Then
        #expect(destination.sentEvents.isEmpty)
    }

    @Test(arguments: [false, true])
    func applyConsentThenForwardsCurrentConsent(isGranted: Bool) {
        // Given
        let destination = AnalyticsDestinationSpy()
        let tracker = makeTracker(isConsentGranted: isGranted, destination: destination)

        // When
        tracker.applyConsent()

        // Then
        #expect(destination.appliedConsents == [isGranted])
    }
}

private extension AnalyticsTrackerTests {
    func makeTracker(
        isConsentGranted: Bool,
        destination: AnalyticsDestinationSpy
    ) -> AnalyticsTracker {
        .init(
            consent: AnalyticsConsentStub(isGranted: isConsentGranted),
            context: .init(appVersion: "1.0", locale: Locale(identifier: "de_DE")),
            destinations: [destination]
        )
    }
}
