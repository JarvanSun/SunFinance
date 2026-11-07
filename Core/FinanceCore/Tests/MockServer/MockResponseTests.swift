//
//  MockResponseTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct MockResponseTests {
    @Test func jsonThenEncodesBodyWithStatus() throws {
        // Given
        let echo = EchoDTO(method: "GET", symbol: "SAP")

        // When
        let response = try MockResponse.json(echo, status: .created)

        // Then
        let body = try JSONDecoder.backend.decode(EchoDTO.self, from: response.body)
        #expect(response.statusCode == 201)
        #expect(body == echo)
    }

    @Test(arguments: [
        (MockResponse.badRequest, 400),
        (.notFound, 404),
        (.internalError, 500),
        (.serviceUnavailable, 503),
    ])
    func presetsThenHaveTheirStatusAndNoBody(response: MockResponse, statusCode: Int) {
        // Then
        #expect(response.statusCode == statusCode)
        #expect(response.body.isEmpty)
    }
}
