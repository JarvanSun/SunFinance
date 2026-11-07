//
//  MarketDataServiceTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct MarketDataServiceTests {
    @Test func quotesWhenServerRespondsThenReturnsRequestedQuotes() async throws {
        // Given
        let service = makeService(behavior: .instant)

        // When
        let quotes = try await service.quotes(for: ["SAP", "AAPL"])

        // Then
        #expect(quotes.map(\.symbol) == ["SAP", "AAPL"])
    }

    @Test func priceHistoryThenReturnsTheRequestedRange() async throws {
        // Given
        let service = makeService(behavior: .instant)

        // When
        let history = try await service.priceHistory(for: "AAPL", range: .week)

        // Then
        #expect(history.symbol == "AAPL")
        #expect(history.range == .week)
        #expect(!history.candles.isEmpty)
    }

    @Test func quoteDetailThenReturnsQuoteAndStatistics() async throws {
        // Given
        let service = makeService(behavior: .instant)

        // When
        let detail = try await service.quoteDetail(for: "SAP")

        // Then
        #expect(detail.quote.symbol == "SAP")
        #expect(detail.open.currency == .eur)
    }

    @Test func symbolsThenReturnsMatchesWithTheirListing() async throws {
        // Given
        let service = makeService(behavior: .instant)

        // When
        let matches = try await service.symbols(matching: "siemens")

        // Then
        #expect(matches.map(\.symbol) == ["SIE"])
        #expect(matches.first?.currency == .eur)
        #expect(matches.first?.exchange == "XETRA")
    }

    @Test func quotesWhenServerFailsThenThrowsServerError() async {
        // Given
        let service = makeService(behavior: .alwaysFailing)

        // Then
        await #expect(throws: MarketDataError.server(statusCode: 503)) {
            try await service.quotes(for: ["AAPL"])
        }
    }
}

private extension MarketDataServiceTests {
    func makeService(behavior: MockServerBehavior) -> MarketDataService {
        let routes = MarketDataMockRoutes(exchange: MockExchange())
        let server = MockServer(routes: [routes], behavior: behavior)
        return .init(client: BackendClient(environment: .init(mockServer: server)))
    }
}
