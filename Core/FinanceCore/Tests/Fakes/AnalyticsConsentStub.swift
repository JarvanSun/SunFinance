//
//  AnalyticsConsentStub.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

@testable import FinanceCore

final class AnalyticsConsentStub: AnalyticsConsentProviding {
    let isAnalyticsConsentGranted: Bool

    init(isGranted: Bool) {
        isAnalyticsConsentGranted = isGranted
    }
}
