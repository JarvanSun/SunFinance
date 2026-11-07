//
//  AnalyticsTrackerSpy.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

final class AnalyticsTrackerSpy: AnalyticsTracking {
    private(set) var trackedEvents: [any AnalyticsEvent] = []

    func track(_ event: some AnalyticsEvent) {
        trackedEvents.append(event)
    }

    func events<Event: AnalyticsEvent>(of type: Event.Type) -> [Event] {
        trackedEvents.compactMap { $0 as? Event }
    }
}
