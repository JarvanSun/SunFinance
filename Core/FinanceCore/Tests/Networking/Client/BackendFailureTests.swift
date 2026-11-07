//
//  BackendFailureTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore
import Testing

@testable import FinanceCore

struct BackendFailureTests {
    @Test(arguments: [
        (URLError(.notConnectedToInternet) as any Error, BackendFailure.offline),
        (CancellationError(), .cancelled),
        (DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "")), .decoding),
        (BackendFailure.server(statusCode: 500), .server(statusCode: 500)),
    ])
    func initThenMapsTransportErrorToDomainError(error: any Error, expected: BackendFailure) {
        // When
        let mappedError = BackendFailure(error)

        // Then
        #expect(mappedError == expected)
    }

    @Test func initWhenHTTPErrorThenKeepsStatusCode() throws {
        // Given
        let url = try #require(URL(string: "https://api.sunfinance.example"))
        let response = try #require(
            HTTPURLResponse(url: url, statusCode: 502, httpVersion: nil, headerFields: nil)
        )
        let error = HTTPError(response: HTTPResponse(data: Data(), response: response))

        // When
        let mappedError = BackendFailure(error)

        // Then
        #expect(mappedError == .server(statusCode: 502))
    }
}
