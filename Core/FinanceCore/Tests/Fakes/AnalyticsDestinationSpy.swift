//
//  AnalyticsDestinationSpy.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

@testable import FinanceCore

final class AnalyticsDestinationSpy: AnalyticsDestination {
    private(set) var sentEvents: [TrackedEvent] = []
    private(set) var appliedConsents: [Bool] = []

    func send(_ event: TrackedEvent) {
        sentEvents.append(event)
    }

    func applyConsent(_ isGranted: Bool) {
        appliedConsents.append(isGranted)
    }
}
