//
//  MockServerTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct MockServerTests {
    @Test func respondWhenARouteHandlesPathThenReturnsItsResponse() async throws {
        // Given
        let server = makeServer(behavior: .instant)

        // When
        let (data, response) = try await server.respond(to: request(path: "v1/echo?symbol=SAP"))

        // Then
        #expect((response as? HTTPURLResponse)?.statusCode == 200)
        #expect(
            try JSONDecoder().decode(EchoDTO.self, from: data)
                == .init(method: "GET", symbol: "SAP")
        )
    }

    @Test func respondWhenNoRouteHandlesPathThenReturnsNotFound() async throws {
        // Given
        let server = makeServer(behavior: .instant)

        // When
        let (_, response) = try await server.respond(to: request(path: "v1/unknown"))

        // Then
        #expect((response as? HTTPURLResponse)?.statusCode == 404)
    }

    @Test func respondWhenReadsAlwaysFailThenReadIsUnavailable() async throws {
        // Given
        let server = makeServer(behavior: .alwaysFailing)

        // When
        let (_, response) = try await server.respond(to: request(path: "v1/echo"))

        // Then
        #expect((response as? HTTPURLResponse)?.statusCode == 503)
    }

    @Test func respondWhenOnlyReadsFailThenWriteStillSucceeds() async throws {
        // Given
        let server = makeServer(behavior: .init(latency: .zero...(.zero), readFailureRate: 1))
        var write = try request(path: "v1/echo")
        write.httpMethod = "POST"

        // When
        let (_, response) = try await server.respond(to: write)

        // Then
        #expect((response as? HTTPURLResponse)?.statusCode == 200)
    }

    @Test func respondWhenAlwaysFailingThenWriteIsUnavailable() async throws {
        // Given
        let server = makeServer(behavior: .alwaysFailing)
        var write = try request(path: "v1/echo")
        write.httpMethod = "POST"

        // When
        let (_, response) = try await server.respond(to: write)

        // Then
        #expect((response as? HTTPURLResponse)?.statusCode == 503)
    }
}

private extension MockServerTests {
    func makeServer(behavior: MockServerBehavior) -> MockServer {
        MockServer(routes: [EchoRoute(path: ["v1", "echo"])], behavior: behavior)
    }

    func request(path: String) throws -> URLRequest {
        URLRequest(url: try #require(URL(string: "https://api.sunfinance.example/\(path)")))
    }
}
