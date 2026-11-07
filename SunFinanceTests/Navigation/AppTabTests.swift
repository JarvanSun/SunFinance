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
        // Then
        #expect(tab.title.key == key)
        #expect(tab.image == image)
    }

    @Test func allCasesThenStartWithWatchlist() {
        // Then
        #expect(AppTab.allCases == [.watchlist, .portfolio, .orders])
    }
}
