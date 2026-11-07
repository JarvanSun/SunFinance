//
//  BrokerageErrorTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct BrokerageErrorTests {
    @Test(arguments: [
        (BackendFailure.offline, BrokerageError.offline),
        (.server(statusCode: 503), .server(statusCode: 503)),
        (.decoding, .decoding),
        (.cancelled, .cancelled),
    ])
    func initThenMapsEveryBackendFailure(failure: BackendFailure, expected: BrokerageError) {
        // Given / When
        let error = BrokerageError(failure)

        // Then
        #expect(error == expected)
    }
}
