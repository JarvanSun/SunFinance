//
//  PreviewOrderRequestTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore
import Testing

@testable import FinanceCore

struct PreviewOrderRequestTests {
    @Test func requestThenPostsTheDraft() throws {
        // Given
        let draft = OrderDraft.make(.sell, .euros(500), execution: .limit(120))
        let request = PreviewOrderRequest(draft: draft)

        // When
        let body = try #require(try request.body?.encode(using: .backend))

        // Then
        let sent = try OrderDraft(JSONDecoder.backend.decode(OrderDraftDTO.self, from: body))
        #expect(request.path == ["v1", "orders", "preview"])
        #expect(request.method == .post)
        #expect(request.headers.isEmpty)
        #expect(sent == draft)
    }
}
