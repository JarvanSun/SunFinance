//
//  SymbolOrdersTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct SymbolOrdersTests {
    @Test func allOrdersThenFollowsEveryPageForTheSymbol() async throws {
        // Given
        let provider = OrderProviderStub(pages: [
            nil: .success(Page(elements: [order("1"), order("2")], nextCursor: "2")),
            "2": .success(Page(elements: [order("3")], nextCursor: nil)),
        ])

        // When
        let orders = try await provider.allOrders(.open, for: "AAPL")

        // Then
        #expect(orders.map(\.id) == ["1", "2", "3"])
        #expect(
            provider.requests == [
                .init(filter: .open, symbol: "AAPL", cursor: nil),
                .init(filter: .open, symbol: "AAPL", cursor: "2"),
            ]
        )
    }

    @Test func allOrdersWhenAPageFailsThenThrowsItsError() async {
        // Given
        let provider = OrderProviderStub(pages: [
            nil: .success(Page(elements: [order("1")], nextCursor: "1")),
            "1": .failure(.offline),
        ])

        // Then
        await #expect(throws: BrokerageError.offline) {
            try await provider.allOrders(.past, for: "AAPL")
        }
    }
}

private extension SymbolOrdersTests {
    func order(_ id: Order.ID) -> Order {
        Order(
            id: id,
            draft: .make(symbol: "AAPL"),
            quantity: 1,
            currency: .usd,
            status: .waitingForPrice,
            createdAt: Date(timeIntervalSince1970: 0),
            fill: nil
        )
    }
}
