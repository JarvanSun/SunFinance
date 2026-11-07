//
//  AppTextTests.swift
//  SunFinanceTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import SunFinance

struct AppTextTests {
    @Test func textThenEveryTabTitleIsTranslated() {
        // Given
        let texts = [AppText.watchlistTab, AppText.portfolioTab, AppText.ordersTab]

        // When
        let resolved = texts.map { String(localized: $0) }

        // Then
        #expect(resolved.allSatisfy { !$0.isEmpty && !$0.hasPrefix("app.tab") })
        #expect(Set(resolved).count == texts.count)
    }
}
