//
//  QuoteDetailIssuePresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

@testable import Instrument

struct QuoteDetailIssuePresentationTests {
    @Test(arguments: [
        (QuoteDetailIssue.offline, "quoteDetail.placeholder.offline.message", FinanceImage.offline),
        (.serviceUnavailable, "quoteDetail.placeholder.unavailable.message", .warning),
        (.unreadableData, "quoteDetail.placeholder.unavailable.message", .warning),
    ])
    func messageAndImageThenExplainTheIssue(
        issue: QuoteDetailIssue,
        messageKey: String,
        image: FinanceImage
    ) {
        #expect(issue.message.key == messageKey)
        #expect(issue.image == image)
    }
}
