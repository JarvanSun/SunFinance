//
//  TradingIssueTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Instrument

struct TradingIssueTests {
    @Test(arguments: [
        (BrokerageError.offline, TradingIssue.offline),
        (.server(statusCode: 503), .serviceUnavailable),
        (.decoding, .serviceUnavailable),
        (.cancelled, .serviceUnavailable),
    ])
    func initWhenBrokerageFailsThenNamesTheIssue(error: BrokerageError, expected: TradingIssue) {
        #expect(TradingIssue(error) == expected)
    }

    @Test(arguments: [
        (MarketDataError.offline, TradingIssue.offline),
        (.server(statusCode: 500), .serviceUnavailable),
        (.decoding, .serviceUnavailable),
        (.cancelled, .serviceUnavailable),
    ])
    func initWhenMarketDataFailsThenNamesTheIssue(error: MarketDataError, expected: TradingIssue) {
        #expect(TradingIssue(error) == expected)
    }

    @Test(arguments: [
        (TradingIssue.offline, "offline"),
        (.serviceUnavailable, "service_unavailable"),
    ])
    func analyticsReasonThenIsSnakeCase(issue: TradingIssue, reason: String) {
        #expect(issue.analyticsReason == reason)
    }
}
