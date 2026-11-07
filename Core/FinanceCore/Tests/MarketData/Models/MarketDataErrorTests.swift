//
//  MarketDataErrorTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct MarketDataErrorTests {
    @Test(arguments: [
        (BackendFailure.offline, MarketDataError.offline),
        (.server(statusCode: 503), .server(statusCode: 503)),
        (.decoding, .decoding),
        (.cancelled, .cancelled),
    ])
    func initThenMapsEveryBackendFailure(failure: BackendFailure, expected: MarketDataError) {
        // Given / When
        let error = MarketDataError(failure)

        // Then
        #expect(error == expected)
    }
}
