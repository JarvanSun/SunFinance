//
//  MarketDataMockRoutesTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore
import Testing

@testable import FinanceCore

struct MarketDataMockRoutesTests {
    @Test func responseWhenQuotesRequestedThenReturnsOnlyKnownRequestedSymbols() throws {
        // Given
        let request = makeRequest(["v1", "quotes"], query: ("symbols", "SAP,ZZZZ,AAPL"))

        // When
        let response = try #require(try makeRoutes().response(to: request))
        let body = try makeBackendDecoder().decode(QuotesResponseDTO.self, from: response.body)

        // Then
        #expect(response.statusCode == 200)
        #expect(body.quotes.map(\.symbol) == ["SAP", "AAPL"])
        #expect(body.quotes.first?.currency == "EUR")
    }

    @Test func responseWhenHistoryRequestedThenReturnsCandlesOfTheRange() throws {
        // Given
        let request = makeRequest(["v1", "symbols", "SAP", "history"], query: ("range", "1Y"))

        // When
        let response = try #require(try makeRoutes().response(to: request))
        let body = try makeBackendDecoder().decode(
            PriceHistoryResponseDTO.self,
            from: response.body
        )

        // Then
        #expect(body.range == "1Y")
        #expect(body.candles.count == 252)
        #expect(body.previousClose == nil)
    }

    @Test(arguments: [nil, "2D"])
    func responseWhenHistoryRangeIsMissingOrUnknownThenIsBadRequest(range: String?) throws {
        // Given
        let request = makeRequest(
            ["v1", "symbols", "SAP", "history"],
            query: range.map { ("range", $0) }
        )

        // Then
        #expect(try makeRoutes().response(to: request)?.statusCode == 400)
    }

    @Test func responseWhenDetailRequestedThenRangesContainThePrice() throws {
        // Given
        let request = makeRequest(["v1", "symbols", "AAPL"])

        // When
        let response = try #require(try makeRoutes().response(to: request))
        let body = try makeBackendDecoder().decode(QuoteDetailResponseDTO.self, from: response.body)

        // Then
        #expect(body.dayLow <= body.dayHigh)
        #expect(body.yearLow <= body.dayLow)
        #expect(body.yearHigh >= body.dayHigh)
        #expect(body.volume > 0)
    }

    @Test(arguments: [
        ("sap", ["SAP"]),
        ("a", ["AAPL", "AMZN", "ASML", "ALV"]),
        ("corporation", ["NVDA", "MSFT"]),
        ("zzz", []),
        ("  ", []),
    ])
    func responseWhenSearchingThenRanksExactSymbolPrefixThenName(
        query: String,
        expectedPrefixes: [String]
    ) throws {
        // Given
        let request = makeRequest(["v1", "search"], query: ("query", query))

        // When
        let response = try #require(try makeRoutes().response(to: request))
        let body = try makeBackendDecoder().decode(
            SymbolSearchResponseDTO.self,
            from: response.body
        )

        // Then
        let symbols = body.matches.prefix(expectedPrefixes.count).map(\.symbol)
        #expect(zip(symbols, expectedPrefixes).allSatisfy { $0.hasPrefix($1) })
        #expect(symbols.count == expectedPrefixes.count)
    }

    @Test func responseWhenSearchingASymbolThenExactMatchComesFirstWithItsListing() throws {
        // Given
        let request = makeRequest(["v1", "search"], query: ("query", "ko"))

        // When
        let response = try #require(try makeRoutes().response(to: request))
        let body = try makeBackendDecoder().decode(
            SymbolSearchResponseDTO.self,
            from: response.body
        )

        // Then
        let first = try #require(body.matches.first)
        #expect(first.symbol == "KO")
        #expect(first.exchange == "NYSE")
        #expect(first.currency == "USD")
        #expect(body.matches.count <= 10)
    }

    @Test func responseWhenSearchHasNoQueryThenIsBadRequest() throws {
        // Given
        let request = makeRequest(["v1", "search"])

        // Then
        #expect(try makeRoutes().response(to: request)?.statusCode == 400)
    }

    @Test func responseWhenSymbolIsUnknownThenIsNotFound() throws {
        // Given
        let request = makeRequest(["v1", "symbols", "ZZZZ"])

        // Then
        #expect(try makeRoutes().response(to: request)?.statusCode == 404)
    }

    @Test(arguments: [(["v1", "orders"], HTTPMethod.get), (["v1", "quotes"], .post)])
    func responseWhenRequestIsNotMarketDataThenIsNil(path: [String], method: HTTPMethod) throws {
        // Given
        let request = MockRequest(method: method, path: path, date: Date())

        // Then
        #expect(try makeRoutes().response(to: request) == nil)
    }
}

private extension MarketDataMockRoutesTests {
    func makeRoutes() -> MarketDataMockRoutes {
        MarketDataMockRoutes(exchange: MockExchange())
    }

    func makeRequest(_ path: [String], query: (String, String)? = nil) -> MockRequest {
        MockRequest(
            method: .get,
            path: path,
            queryItems: query.map { [URLQueryItem(name: $0.0, value: $0.1)] } ?? [],
            date: Date(timeIntervalSince1970: 1_793_000_000)
        )
    }
}
