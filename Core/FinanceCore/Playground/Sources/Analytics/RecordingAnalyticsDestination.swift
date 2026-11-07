//
//  RecordingAnalyticsDestination.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Observation

@Observable
final class RecordingAnalyticsDestination: AnalyticsDestination {
    private(set) var receivedEvents: [TrackedEvent] = []
    private(set) var isConsentGranted = false

    func send(_ event: TrackedEvent) {
        receivedEvents.insert(event, at: 0)
    }

    func applyConsent(_ isGranted: Bool) {
        isConsentGranted = isGranted
    }
}
