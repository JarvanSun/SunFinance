//
//  MarketEndpointTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore
import Testing

@testable import FinanceCore

struct MarketEndpointTests {
    @Test(arguments: [
        (MarketEndpoint.quotes, ["v1", "quotes"]),
        (.quoteDetail("SAP"), ["v1", "symbols", "SAP"]),
        (.priceHistory("SAP"), ["v1", "symbols", "SAP", "history"]),
        (.symbolSearch, ["v1", "search"]),
    ])
    func pathThenIsVersionedPathOfTheEndpoint(endpoint: MarketEndpoint, expected: [String]) {
        // Then
        #expect(endpoint.path == expected)
        #expect(endpoint.method == .get)
    }

    @Test(arguments: [
        (["v1", "quotes"], MarketEndpoint?.some(.quotes)),
        (["v1", "symbols", "SAP"], .quoteDetail("SAP")),
        (["v1", "symbols", "SAP", "history"], .priceHistory("SAP")),
        (["v1", "search"], .symbolSearch),
        (["v1", "symbols", "SAP", "news"], nil),
        (["v2", "quotes"], nil),
    ])
    func initWithPathThenMatchesOnlyKnownEndpoints(path: [String], expected: MarketEndpoint?) {
        // When
        let endpoint = MarketEndpoint(path: path, method: .get)

        // Then
        #expect(endpoint == expected)
    }

    @Test func initWhenMethodDoesNotMatchThenIsNil() {
        // When
        let endpoint = MarketEndpoint(path: ["v1", "quotes"], method: .post)

        // Then
        #expect(endpoint == nil)
    }
}
