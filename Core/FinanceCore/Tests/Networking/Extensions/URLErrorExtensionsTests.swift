//
//  URLErrorExtensionsTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct URLErrorExtensionsTests {
    @Test(arguments: [
        (URLError.Code.notConnectedToInternet, true),
        (.timedOut, true),
        (.badURL, false),
    ])
    func isConnectivityFailureThenMatchesConnectivityCodes(code: URLError.Code, expected: Bool) {
        // When
        let isConnectivityFailure = URLError(code).isConnectivityFailure

        // Then
        #expect(isConnectivityFailure == expected)
    }
}
