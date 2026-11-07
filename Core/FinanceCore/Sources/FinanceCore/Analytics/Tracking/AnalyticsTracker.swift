//
//  AnalyticsTracker.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

@MainActor
public final class AnalyticsTracker: AnalyticsTracking {
    private let consent: any AnalyticsConsentProviding
    private let context: AnalyticsContext
    private let destinations: [any AnalyticsDestination]

    public init(
        consent: some AnalyticsConsentProviding,
        context: AnalyticsContext,
        destinations: [any AnalyticsDestination]
    ) {
        self.consent = consent
        self.context = context
        self.destinations = destinations
    }

    public func track(_ event: some AnalyticsEvent) {
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
    func isFreeOfPersonalData(_ event: some AnalyticsEvent) -> Bool {
        !event.parameters.keys.contains { $0.isPersonalData }
    }

    func enriched(_ event: some AnalyticsEvent) -> TrackedEvent {
        let parameters = event.parameters.merging(context.parameters) { eventValue, _ in
            eventValue
        }
        return TrackedEvent(name: event.name, parameters: parameters)
    }

    func forward(_ event: TrackedEvent) {
        for destination in destinations {
            destination.send(event)
        }
    }
}
