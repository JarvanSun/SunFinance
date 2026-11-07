//
//  PortfolioTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct PortfolioTests {
    @Test func initThenMapsOpenAndClosedPositions() throws {
        // Given / When
        let portfolio = try Portfolio(
            PositionsResponseDTO(open: [.dummy(symbol: "AAPL")], closed: [.dummy(symbol: "KO")])
        )

        // Then
        #expect(portfolio.open.map(\.symbol) == ["AAPL"])
        #expect(portfolio.closed.map(\.symbol) == ["KO"])
    }

    @Test func initWhenAPositionIsInvalidThenThrowsDecoding() {
        // Given / When
        let result = Result { () throws(BrokerageError) in
            try Portfolio(PositionsResponseDTO(open: [], closed: [.dummy(currency: "?")]))
        }

        // Then
        #expect(result.failure == .decoding)
    }

    @Test func positionThenFindsOnlyOpenPositions() throws {
        // Given
        let portfolio = try Portfolio(
            PositionsResponseDTO(open: [.dummy(symbol: "AAPL")], closed: [.dummy(symbol: "KO")])
        )

        // Then
        #expect(portfolio.position(of: "AAPL")?.symbol == "AAPL")
        #expect(portfolio.position(of: "KO") == nil)
    }
}
