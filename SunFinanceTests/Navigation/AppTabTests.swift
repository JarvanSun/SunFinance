//
//  AppTabTests.swift
//  SunFinanceTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

@testable import SunFinance

struct AppTabTests {
    @Test(arguments: [
        (AppTab.watchlist, "app.tab.watchlist", FinanceImage.watchlist),
        (.portfolio, "app.tab.portfolio", .portfolio),
        (.orders, "app.tab.orders", .orders),
    ])
    func presentationThenNamesAndPicturesEveryTab(tab: AppTab, key: String, image: FinanceImage) {
        #expect(tab.title.key == key)
        #expect(tab.image == image)
    }

    @Test func titleThenEveryTabIsTranslated() {
        // Given / When
        let resolved = AppTab.allCases.map { String(localized: $0.title) }

        // Then
        #expect(resolved.allSatisfy { !$0.isEmpty && !$0.hasPrefix("app.tab") })
        #expect(Set(resolved).count == AppTab.allCases.count)
    }

    @Test func allCasesThenStartWithWatchlist() {
        #expect(AppTab.allCases == [.watchlist, .portfolio, .orders])
    }
}
