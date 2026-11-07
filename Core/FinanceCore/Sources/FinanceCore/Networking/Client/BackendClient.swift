//
//  BackendClient.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore

struct BackendClient: Sendable {
    private let client: APIClient

    init(environment: ServerEnvironment) {
        client = environment.makeAPIClient()
    }

    func send<Request: APIRequest>(
        _ request: Request
    ) async throws(BackendFailure) -> Request.Response {
        do {
            return try await client.send(request)
        } catch {
            throw BackendFailure(error)
        }
    }
}

private extension ServerEnvironment {
    func makeAPIClient() -> APIClient {
        .init(
            sender: makeSender(),
            requestBuilder: RequestBuilder(baseURL: baseURL) { BackendCoding().encoder },
            responseDecoder: ResponseDecoder { BackendCoding().decoder }
        )
    }

    func makeSender() -> RequestSending {
        switch transport {
        case .urlSession: RequestSender()
        case .mock(let server): server.makeSender()
        }
    }
}
