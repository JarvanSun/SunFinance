//
//  MockRequestTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore
import Testing

@testable import FinanceCore

struct MockRequestTests {
    @Test func initThenSplitsPathAndReadsQueryAndHeaders() throws {
        // Given
        let url = try #require(
            URL(string: "https://api.sunfinance.example/v1/quotes?symbols=AAPL,SAP")
        )
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("key-1", forHTTPHeaderField: "idempotency-key")
        let date = Date(timeIntervalSince1970: 0)

        // When
        let request = MockRequest(urlRequest, date: date)

        // Then
        #expect(request.path == ["v1", "quotes"])
        #expect(request.query("symbols") == "AAPL,SAP")
        #expect(request.header(.idempotencyKey) == "key-1")
        #expect(request.isRead)
        #expect(request.date == date)
    }

    @Test func initWhenMethodIsPostThenIsNotARead() throws {
        // Given
        let url = try #require(URL(string: "https://api.sunfinance.example"))
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        // When
        let request = MockRequest(urlRequest, date: Date(timeIntervalSince1970: 0))

        // Then
        #expect(request.method == .post)
        #expect(!request.isRead)
    }
}
