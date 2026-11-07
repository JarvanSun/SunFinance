//
//  LedgerOrderTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct LedgerOrderTests {
    @Test(arguments: [OrderRejection?.none, .insufficientShares])
    func codableThenRoundTripsTheDraftAndRejection(rejection: OrderRejection?) throws {
        // Given
        let order = LedgerOrder(
            id: "order-1",
            draft: .dummy(.sell, .euros(300), execution: .limit(99), validity: .goodTillCancelled),
            quantity: 3,
            createdAt: Date(timeIntervalSince1970: 100),
            state: .working,
            releasedAt: Date(timeIntervalSince1970: 200),
            rejection: rejection,
            fillID: nil
        )

        // When
        let data = try BackendCoding().encoder.encode(order)
        let decoded = try BackendCoding().decoder.decode(LedgerOrder.self, from: data)

        // Then
        #expect(decoded == order)
    }

    @Test func decodeWhenRejectionIsUnknownThenThrows() throws {
        // Given
        let order = LedgerOrder(
            id: "order-1",
            draft: .dummy(),
            quantity: 1,
            createdAt: Date(timeIntervalSince1970: 100),
            state: .rejected,
            releasedAt: nil,
            rejection: .invalidPrice,
            fillID: nil
        )
        let json = String(decoding: try BackendCoding().encoder.encode(order), as: UTF8.self)
        let data = Data(json.replacingOccurrences(of: "invalid_price", with: "too_late").utf8)

        // Then
        #expect(throws: DecodingError.self) {
            try BackendCoding().decoder.decode(LedgerOrder.self, from: data)
        }
    }
}
