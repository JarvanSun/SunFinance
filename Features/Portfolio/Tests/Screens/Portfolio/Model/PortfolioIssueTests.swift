//
//  PortfolioIssueTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Portfolio

struct PortfolioIssueTests {
    @Test(arguments: [
        (BrokerageError.offline, PortfolioIssue.offline),
        (.server(statusCode: 503), .serviceUnavailable),
        (.decoding, .serviceUnavailable),
        (.cancelled, .serviceUnavailable),
    ])
    func initThenNamesTheIssue(error: BrokerageError, expected: PortfolioIssue) {
        // Then
        #expect(PortfolioIssue(error) == expected)
    }
}
