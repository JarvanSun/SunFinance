//
//  MockResponse.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct MockResponse: Equatable, Sendable {
    let statusCode: Int
    let body: Data

    init(status: HTTPStatus, body: Data = Data()) {
        statusCode = status.rawValue
        self.body = body
    }

    init(json value: some Encodable, status: HTTPStatus = .ok) throws {
        self.init(status: status, body: try makeBackendEncoder().encode(value))
    }
}
