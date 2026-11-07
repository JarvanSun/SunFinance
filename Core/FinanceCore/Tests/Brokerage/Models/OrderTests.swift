//
//  OrderTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct OrderTests {
    @Test func initThenMapsEveryField() throws {
        // Given
        let draft = OrderDraft.make(.buy, .euros(200), symbol: "AAPL")

        // When
        let order = try Order(dto(draft: draft, fill: .make()))

        // Then
        #expect(order.id == "order-1")
        #expect(order.draft == draft)
        #expect(order.quantity == 2)
        #expect(order.currency == .usd)
        #expect(order.status == .filled)
        #expect(order.createdAt == Date(timeIntervalSince1970: 500))
        #expect(order.fill == (try OrderFill(.make())))
    }

    @Test(arguments: [("filled", "DOLLAR"), ("lost", "USD"), ("rejected", "USD")])
    func initWhenStatusOrCurrencyIsInvalidThenThrowsDecoding(status: String, currency: String) {
        // When
        let result = Result { () throws(BrokerageError) in
            try Order(dto(status: status, currency: currency))
        }

        // Then
        #expect(result.failure == .decoding)
    }
}

private extension OrderTests {
    func dto(
        draft: OrderDraft = .make(),
        status: String = "filled",
        currency: String = "USD",
        fill: FillDTO? = nil
    ) -> OrderDTO {
        OrderDTO(
            id: "order-1",
            draft: draft.dto,
            quantity: 2,
            currency: currency,
            status: status,
            rejection: nil,
            createdAt: Date(timeIntervalSince1970: 500),
            fill: fill
        )
    }
}
