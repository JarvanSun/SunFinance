//
//  EchoRoute.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore

@testable import FinanceCore

struct EchoRoute: MockRoute {
    let path: [String]

    func response(to request: MockRequest) throws -> MockResponse? {
        guard request.path == path else { return nil }

        return try .json(
            EchoDTO(method: request.method.rawValue, symbol: request.query("symbol"))
        )
    }
}

struct EchoDTO: Codable, Equatable, Sendable {
    let method: String
    let symbol: String?
}
