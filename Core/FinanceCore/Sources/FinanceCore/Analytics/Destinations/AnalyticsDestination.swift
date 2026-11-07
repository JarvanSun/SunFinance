//
//  AnalyticsDestination.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

@MainActor
public protocol AnalyticsDestination: AnyObject {
    func send(_ event: TrackedEvent)
    func applyConsent(_ isGranted: Bool)
}
