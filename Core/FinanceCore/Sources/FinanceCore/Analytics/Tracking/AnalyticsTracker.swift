//
//  AnalyticsTracker.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

@MainActor
public final class AnalyticsTracker: AnalyticsTracking {
    private let consent: AnalyticsConsentProviding
    private let context: AnalyticsContext
    private let destinations: [AnalyticsDestination]

    public init(
        consent: AnalyticsConsentProviding,
        context: AnalyticsContext,
        destinations: [AnalyticsDestination]
    ) {
        self.consent = consent
        self.context = context
        self.destinations = destinations
    }

    public func track(_ event: AnalyticsEvent) {
        guard consent.isAnalyticsConsentGranted, isFreeOfPersonalData(event) else { return }

        forward(enriched(event))
    }

    public func applyConsent() {
        for destination in destinations {
            destination.applyConsent(consent.isAnalyticsConsentGranted)
        }
    }
}

private extension AnalyticsTracker {
    func isFreeOfPersonalData(_ event: AnalyticsEvent) -> Bool {
        !event.parameters.keys.contains { $0.isPersonalData }
    }

    func enriched(_ event: AnalyticsEvent) -> TrackedEvent {
        let parameters = event.parameters.merging(context.parameters) { eventValue, _ in
            eventValue
        }
        return .init(name: event.name, parameters: parameters)
    }

    func forward(_ event: TrackedEvent) {
        for destination in destinations {
            destination.send(event)
        }
    }
}
