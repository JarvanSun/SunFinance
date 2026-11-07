//
//  AnalyticsTracking.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

@MainActor
public protocol AnalyticsTracking: AnyObject {
    func track(_ event: some AnalyticsEvent)
}
