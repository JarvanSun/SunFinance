//
//  AnalyticsEvent.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

@MainActor
public protocol AnalyticsEvent: Sendable {
    var name: AnalyticsEventName { get }
    var parameters: [AnalyticsParameter: AnalyticsValue] { get }
}
