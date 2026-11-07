//
//  TradingIssuePresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

@testable import Instrument

struct TradingIssuePresentationTests {
    @Test(arguments: [
        (
            TradingIssue.offline,
            "trading.failure.offline.title",
            "trading.failure.offline.message",
            "trading.review.placeFailed.offline",
            FinanceImage.offline
        ),
        (
            .serviceUnavailable,
            "trading.failure.service.title",
            "trading.failure.service.message",
            "trading.review.placeFailed.service",
            .warning
        ),
    ])
    func presentationThenNamesTheIssue(
        issue: TradingIssue,
        title: String,
        message: String,
        placementMessage: String,
        image: FinanceImage
    ) {
        // Then
        #expect(issue.title.key == title)
        #expect(issue.message.key == message)
        #expect(issue.placementMessage.key == placementMessage)
        #expect(issue.image == image)
    }
}
