//
//  ServerEnvironment.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct ServerEnvironment: Sendable {
    let baseURL: URL
    let transport: ServerTransport
}

extension ServerEnvironment {
    public static func mock(behavior: MockServerBehavior, storageDirectory: URL?) -> Self {
        let exchange = MockExchange()
        let brokerage = MockBrokerage(
            exchange: exchange,
            storageURL: storageDirectory?.appending(path: MockStorageFile.brokerage.rawValue)
        )
        let routes: [any MockRoute] = [
            MarketDataMockRoutes(exchange: exchange),
            BrokerageMockRoutes(brokerage: brokerage),
        ]
        return .mock(MockServer(routes: routes, behavior: behavior))
    }

    static func mock(_ server: MockServer) -> Self {
        .init(baseURL: mockBaseURL, transport: .mock(server))
    }

    private static let mockBaseURL = URL(string: "https://api.sunfinance.example")!
}

private enum MockStorageFile: String {
    case brokerage = "brokerage.json"
}
