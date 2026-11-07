//
//  TrackedEvent.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct TrackedEvent: Equatable, Sendable {
    public let name: AnalyticsEventName
    public let parameters: [AnalyticsParameter: AnalyticsValue]
}
