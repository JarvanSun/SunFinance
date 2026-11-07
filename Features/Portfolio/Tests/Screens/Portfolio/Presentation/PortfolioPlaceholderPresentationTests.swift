//
//  PortfolioPlaceholderPresentationTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

@testable import Portfolio

struct PortfolioPlaceholderPresentationTests {
    @Test(arguments: [
        (PortfolioPlaceholder.loading, "portfolio.loading", FinanceImage.emptyWatchlist),
        (.empty, "portfolio.empty.title", .emptyWatchlist),
        (.failed(.offline), "portfolio.failure.offline.title", .offline),
        (.failed(.serviceUnavailable), "portfolio.failure.service.title", .warning),
    ])
    func titleAndImageThenFollowThePlaceholder(
        placeholder: PortfolioPlaceholder,
        title: String,
        image: FinanceImage
    ) {
        // Then
        #expect(placeholder.title.key == title)
        #expect(placeholder.image == image)
    }

    @Test(arguments: [
        (PortfolioPlaceholder.empty, "portfolio.empty.message"),
        (.failed(.offline), "portfolio.failure.offline.message"),
    ])
    func messageThenExplainsThePlaceholder(placeholder: PortfolioPlaceholder, key: String) {
        // Then
        #expect(placeholder.message.key == key)
    }
}
