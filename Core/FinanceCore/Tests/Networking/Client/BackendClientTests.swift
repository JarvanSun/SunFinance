//
//  BackendClientTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct BackendClientTests {
    @Test func sendWhenRouteAnswersThenDecodesResponse() async throws {
        // Given
        let client = makeClient(behavior: .instant)

        // When
        let response = try await client.send(EchoRequest(path: ["v1", "echo"]))

        // Then
        #expect(response == .init(method: "GET", symbol: "AAPL"))
    }

    @Test func sendWhenServerFailsThenThrowsServerFailure() async {
        // Given
        let client = makeClient(behavior: .alwaysFailing)

        // Then
        await #expect(throws: BackendFailure.server(statusCode: 503)) {
            try await client.send(EchoRequest(path: ["v1", "echo"]))
        }
    }
}

private extension BackendClientTests {
    func makeClient(behavior: MockServerBehavior) -> BackendClient {
        let server = MockServer(routes: [EchoRoute(path: ["v1", "echo"])], behavior: behavior)
        return BackendClient(environment: .init(mockServer: server))
    }
}
