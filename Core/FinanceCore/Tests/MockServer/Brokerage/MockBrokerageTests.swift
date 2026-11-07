//
//  MockBrokerageTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct MockBrokerageTests {
    @Test func initWhenFileExistsThenRestoresTheBooks() throws {
        // Given
        let url = FileManager.default.temporaryDirectory.appending(
            path: "\(UUID().uuidString)/ledger.json"
        )
        defer { try? FileManager.default.removeItem(at: url.deletingLastPathComponent()) }
        let date = TradingMoment.tuesdayAfternoon.date
        let first = MockBrokerage(exchange: MockExchange(), storageURL: url, now: date)
        let placed = first.update(at: date) { ledger in
            ledger.place(.init(), key: nil, at: date, exchange: MockExchange())
        }

        // When
        let reopened = MockBrokerage(exchange: MockExchange(), storageURL: url, now: date)
        let restored = reopened.update(at: date) { $0.order(withID: placed.id) }

        // Then
        #expect(restored == placed)
    }
}
