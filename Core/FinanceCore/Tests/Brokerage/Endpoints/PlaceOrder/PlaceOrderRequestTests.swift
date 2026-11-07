//
//  PlaceOrderRequestTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore
import Testing

@testable import FinanceCore

struct PlaceOrderRequestTests {
    @Test func requestThenPostsTheDraftWithItsIdempotencyKey() throws {
        // Given
        let draft = OrderDraft(.buy, .shares(3), trigger: .priceAtOrAbove(150))
        let request = PlaceOrderRequest(draft: draft, idempotencyKey: IdempotencyKey(rawValue: "k"))

        // When
        let body = try #require(try request.body?.encode(using: makeBackendEncoder()))

        // Then
        let sent = try OrderDraft(makeBackendDecoder().decode(OrderDraftDTO.self, from: body))
        #expect(request.path == ["v1", "orders"])
        #expect(request.method == .post)
        #expect(request.headers == ["Idempotency-Key": "k"])
        #expect(sent == draft)
    }
}
