//
//  BrokerageMockRoutesTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore
import Testing

@testable import FinanceCore

struct BrokerageMockRoutesTests {
    @Test(arguments: [
        (["v1", "account"], HTTPMethod.get, [URLQueryItem]()),
        (["v1", "portfolio", "positions"], .get, []),
        (["v1", "portfolio", "history"], .get, [.init(name: "range", value: "1M")]),
        (["v1", "orders"], .get, [.init(name: "status", value: "past")]),
        (
            ["v1", "orders"],
            .get,
            [.init(name: "status", value: "past"), .init(name: "symbol", value: "SAP")]
        ),
    ])
    func responseWhenReadingThenAnswersOK(
        path: [String],
        method: HTTPMethod,
        queryItems: [URLQueryItem]
    ) throws {
        // Given
        let request = MockRequest(method: method, path: path, queryItems: queryItems, date: date)

        // Then
        #expect(try makeRoutes().response(to: request)?.statusCode == 200)
    }

    @Test(arguments: [
        (["v1", "portfolio", "history"], [URLQueryItem]()),
        (["v1", "portfolio", "history"], [.init(name: "range", value: "2W")]),
        (["v1", "orders"], []),
        (["v1", "orders"], [.init(name: "status", value: "all")]),
    ])
    func responseWhenAQueryIsMissingOrUnknownThenIsBadRequest(
        path: [String],
        queryItems: [URLQueryItem]
    ) throws {
        // Given
        let request = MockRequest(method: .get, path: path, queryItems: queryItems, date: date)

        // Then
        #expect(try makeRoutes().response(to: request)?.statusCode == 400)
    }

    @Test(arguments: [["v1", "orders"], ["v1", "orders", "preview"]])
    func responseWhenOrderBodyIsMalformedThenIsBadRequest(path: [String]) throws {
        // Given
        let request = MockRequest(method: .post, path: path, body: Data("{}".utf8), date: date)

        // Then
        #expect(try makeRoutes().response(to: request)?.statusCode == 400)
    }

    @Test func responseWhenPlacingThenCreatesTheOrderOnce() throws {
        // Given
        let routes = makeRoutes()
        let request = MockRequest(
            method: .post,
            path: ["v1", "orders"],
            headers: ["Idempotency-Key": "submit-1"],
            body: try makeBackendEncoder().encode(OrderDraft().dto),
            date: date
        )

        // When
        let first = try #require(try routes.response(to: request))
        let second = try #require(try routes.response(to: request))

        // Then
        let firstOrder = try makeBackendDecoder().decode(OrderDTO.self, from: first.body)
        let secondOrder = try makeBackendDecoder().decode(OrderDTO.self, from: second.body)
        #expect(first.statusCode == 201)
        #expect(firstOrder.id == secondOrder.id)
        #expect(firstOrder.status == "filled")
    }

    @Test func responseWhenListingOrdersForASymbolThenReturnsOnlyItsOrders() throws {
        // Given
        let routes = makeRoutes()
        for (key, symbol) in [("sap", "SAP"), ("apple", "AAPL")] {
            let request = MockRequest(
                method: .post,
                path: ["v1", "orders"],
                headers: ["Idempotency-Key": key],
                body: try makeBackendEncoder().encode(
                    OrderDraft(symbol: TickerSymbol(rawValue: symbol)).dto
                ),
                date: date
            )
            _ = try routes.response(to: request)
        }
        let request = MockRequest(
            method: .get,
            path: ["v1", "orders"],
            queryItems: [
                .init(name: "status", value: "past"), .init(name: "symbol", value: "SAP"),
            ],
            date: date
        )

        // When
        let response = try #require(try routes.response(to: request))

        // Then
        let page = try makeBackendDecoder().decode(OrdersResponseDTO.self, from: response.body)
        #expect(page.orders.map(\.draft.symbol) == ["SAP"])
    }

    @Test func responseWhenCancellingAnUnknownOrderThenIsNotFound() throws {
        // Given
        let request = MockRequest(method: .delete, path: ["v1", "orders", "nope"], date: date)

        // Then
        #expect(try makeRoutes().response(to: request)?.statusCode == 404)
    }

    @Test func responseWhenPathIsNotBrokerageThenIsNil() throws {
        // Given
        let request = MockRequest(method: .get, path: ["v1", "quotes"], date: date)

        // Then
        #expect(try makeRoutes().response(to: request) == nil)
    }
}

private extension BrokerageMockRoutesTests {
    var date: Date { TradingMoment.tuesdayAfternoon.date }

    func makeRoutes() -> BrokerageMockRoutes {
        let brokerage = MockBrokerage(exchange: MockExchange(), storageURL: nil, now: date)
        return BrokerageMockRoutes(brokerage: brokerage)
    }
}
