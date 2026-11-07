//
//  AnalyticsConsole.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Observation

@Observable
final class AnalyticsConsole {
    private(set) var sentCount = 0

    var receivedEvents: [TrackedEvent] { destination.receivedEvents }

    var isConsentGranted: Bool { destination.isConsentGranted }

    private let consent: UserDefaultsAnalyticsConsent
    private let destination: RecordingAnalyticsDestination
    private let tracker: AnalyticsTracker

    init() {
        let consent = UserDefaultsAnalyticsConsent(defaults: .standard)
        let destination = RecordingAnalyticsDestination()
        self.consent = consent
        self.destination = destination
        tracker = AnalyticsTracker(
            consent: consent,
            context: AnalyticsContext(appVersion: "playground", locale: .autoupdatingCurrent),
            destinations: [
                destination, ConsoleAnalyticsDestination(subsystem: "FinanceCorePlayground"),
            ]
        )
        tracker.applyConsent()
    }

    func setConsent(_ isGranted: Bool) {
        consent.setConsent(isGranted)
        tracker.applyConsent()
    }

    func send(_ event: PlaygroundEvent) {
        sentCount += 1
        tracker.track(event)
    }
}
