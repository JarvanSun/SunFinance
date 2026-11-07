//
//  QuoteDetailRequestTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore
import Testing

@testable import FinanceCore

struct QuoteDetailRequestTests {
    @Test func requestThenTargetsSymbol() {
        // Given
        let request = QuoteDetailRequest(symbol: "AAPL")

        // Then
        #expect(request.path == ["v1", "symbols", "AAPL"])
        #expect(request.method == .get)
    }
}
