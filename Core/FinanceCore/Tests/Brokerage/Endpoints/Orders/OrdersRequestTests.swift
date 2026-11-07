//
//  OrdersRequestTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore
import Testing

@testable import FinanceCore

struct OrdersRequestTests {
    @Test(arguments: [
        (TickerSymbol?.none, String?.none, [URLQueryItem(name: "status", value: "open")]),
        (
            nil, "20",
            [URLQueryItem(name: "status", value: "open"), .init(name: "cursor", value: "20")]
        ),
        (
            "AAPL",
            "20",
            [
                URLQueryItem(name: "status", value: "open"),
                .init(name: "symbol", value: "AAPL"),
                .init(name: "cursor", value: "20"),
            ]
        ),
    ])
    func requestThenSendsFilterSymbolAndCursor(
        symbol: TickerSymbol?,
        cursor: String?,
        queryItems: [URLQueryItem]
    ) {
        // Given
        let request = OrdersRequest(filter: .open, symbol: symbol, cursor: cursor)

        // Then
        #expect(request.path == ["v1", "orders"])
        #expect(request.method == .get)
        #expect(request.queryItems == queryItems)
        #expect(request.body == nil)
    }
}
