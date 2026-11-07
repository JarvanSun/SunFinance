//
//  QuoteDetailIssueTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Instrument

struct QuoteDetailIssueTests {
    @Test(arguments: [
        (MarketDataError.offline, QuoteDetailIssue.offline),
        (.server(statusCode: 500), .serviceUnavailable),
        (.cancelled, .serviceUnavailable),
        (.decoding, .unreadableData),
    ])
    func initThenMapsEveryMarketDataError(error: MarketDataError, expected: QuoteDetailIssue) {
        // Then
        #expect(QuoteDetailIssue(error) == expected)
    }

    @Test(arguments: [
        (BrokerageError.offline, QuoteDetailIssue.offline),
        (.server(statusCode: 500), .serviceUnavailable),
        (.cancelled, .serviceUnavailable),
        (.decoding, .unreadableData),
    ])
    func initThenMapsEveryBrokerageError(error: BrokerageError, expected: QuoteDetailIssue) {
        // Then
        #expect(QuoteDetailIssue(error) == expected)
    }
}
