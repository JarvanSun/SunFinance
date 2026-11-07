//
//  OrderPreviewTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct OrderPreviewTests {
    @Test(arguments: [
        (String?.none, OrderRejection?.none),
        ("insufficient_cash", .insufficientCash),
    ])
    func initThenMapsEveryField(rejection: String?, expected: OrderRejection?) throws {
        // Given / When
        let preview = try OrderPreview(dto(rejection: rejection))

        // Then
        #expect(preview.quantity == 2)
        #expect(preview.price == Money(100, .usd))
        #expect(preview.exchangeRate == 0.9)
        #expect(preview.fee == Money(1, .eur))
        #expect(preview.total == Money(181, .eur))
        #expect(preview.cashAfter == Money(819, .eur))
        #expect(preview.rejection == expected)
    }

    @Test func initWhenACurrencyIsInvalidThenThrowsDecoding() {
        // Given / When
        let result = Result { () throws(BrokerageError) in
            try OrderPreview(dto(rejection: nil, priceCurrency: "?"))
        }

        // Then
        #expect(result.failure == .decoding)
    }
}

private extension OrderPreviewTests {
    func dto(rejection: String?, priceCurrency: String = "USD") -> PreviewOrderResponseDTO {
        .init(
            quantity: 2,
            price: MoneyDTO(amount: 100, currency: priceCurrency),
            exchangeRate: 0.9,
            fee: .init(euros: 1),
            total: .init(euros: 181),
            cashAfter: .init(euros: 819),
            rejection: rejection
        )
    }
}
