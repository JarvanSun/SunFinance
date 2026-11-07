//
//  AnalyticsContextTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct AnalyticsContextTests {
    @Test func parametersThenContainAppVersionAndLocale() {
        // Given
        let context = AnalyticsContext(appVersion: "2.1", locale: Locale(identifier: "en_US"))

        // When
        let parameters = context.parameters

        // Then
        #expect(parameters == [.appVersion: .text("2.1"), .locale: .text("en_US")])
    }
}
