//
//  QuotesRequestTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore
import Testing

@testable import FinanceCore

struct QuotesRequestTests {
    @Test func requestThenTargetsQuotesWithJoinedSymbols() {
        // Given
        let request = QuotesRequest(symbols: ["AAPL", "SAP"])

        // Then
        #expect(request.path == MarketEndpoint.quotes.path)
        #expect(request.method == .get)
        #expect(request.queryItems == [URLQueryItem(name: "symbols", value: "AAPL,SAP")])
    }
}
