//
//  PortfolioIssuePresentationTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

@testable import Portfolio

struct PortfolioIssuePresentationTests {
    @Test(arguments: [
        (PortfolioIssue.offline, "offline", FinanceImage.offline),
        (.serviceUnavailable, "service", .warning),
    ])
    func presentationThenNamesTheIssue(issue: PortfolioIssue, name: String, image: FinanceImage) {
        // Then
        #expect(issue.title.key == "portfolio.failure.\(name).title")
        #expect(issue.message.key == "portfolio.failure.\(name).message")
        #expect(issue.image == image)
    }
}
