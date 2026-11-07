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
        let response = try MockResponse(json: echo, status: .created)

        // Then
        let body = try BackendCoding().decoder.decode(EchoDTO.self, from: response.body)
        #expect(response.statusCode == 201)
        #expect(body == echo)
    }

    @Test(arguments: [
        (HTTPStatus.badRequest, 400),
        (.notFound, 404),
        (.internalServerError, 500),
        (.serviceUnavailable, 503),
    ])
    func initWithStatusThenHasItsCodeAndNoBody(status: HTTPStatus, statusCode: Int) {
        // Given / When
        let response = MockResponse(status: status)

        // Then
        #expect(response.statusCode == statusCode)
        #expect(response.body.isEmpty)
    }
}
