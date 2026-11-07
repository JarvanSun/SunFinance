//
//  BrokerageEndpointTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore
import Testing

@testable import FinanceCore

struct BrokerageEndpointTests {
    @Test(arguments: [
        (BrokerageEndpoint.account, ["v1", "account"], HTTPMethod.get),
        (.positions, ["v1", "portfolio", "positions"], .get),
        (.portfolioHistory, ["v1", "portfolio", "history"], .get),
        (.orders, ["v1", "orders"], .get),
        (.previewOrder, ["v1", "orders", "preview"], .post),
        (.placeOrder, ["v1", "orders"], .post),
        (.cancelOrder("order-1"), ["v1", "orders", "order-1"], .delete),
    ])
    func pathAndMethodThenMatchTheCatalogue(
        endpoint: BrokerageEndpoint,
        path: [String],
        method: HTTPMethod
    ) {
        #expect(endpoint.path == path)
        #expect(endpoint.method == method)
        #expect(BrokerageEndpoint(path: path, method: method) == endpoint)
    }

    @Test(arguments: [
        (["v1", "orders"], HTTPMethod.delete),
        (["v1", "orders", "order-1"], .get),
        (["v1", "account"], .post),
        (["v2", "account"], .get),
        (["v1", "quotes"], .get),
    ])
    func initWhenPathOrMethodIsUnknownThenIsNil(path: [String], method: HTTPMethod) {
        // Given / When
        let endpoint = BrokerageEndpoint(path: path, method: method)

        // Then
        #expect(endpoint == nil)
    }
}
