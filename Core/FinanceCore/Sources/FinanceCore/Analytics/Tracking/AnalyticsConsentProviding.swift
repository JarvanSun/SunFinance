//
//  AnalyticsConsentProviding.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

@MainActor
public protocol AnalyticsConsentProviding: AnyObject {
    var isAnalyticsConsentGranted: Bool { get }
}
