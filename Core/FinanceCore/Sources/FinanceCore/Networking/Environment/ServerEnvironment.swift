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
    public init(mockBehavior: MockServerBehavior, storageDirectory: URL?) {
        let exchange = MockExchange()
        let brokerage = MockBrokerage(
            exchange: exchange,
            storageURL: storageDirectory?.appending(path: MockStorageFile.brokerage.rawValue)
        )
        let routes: [any MockRoute] = [
            MarketDataMockRoutes(exchange: exchange),
            BrokerageMockRoutes(brokerage: brokerage),
        ]
        self.init(mockServer: MockServer(routes: routes, behavior: mockBehavior))
    }

    init(mockServer: MockServer) {
        self.init(baseURL: mockBaseURL, transport: .mock(mockServer))
    }
}

private enum MockStorageFile: String {
    case brokerage = "brokerage.json"
}

private let mockBaseURL = URL(string: "https://api.sunfinance.example")!
