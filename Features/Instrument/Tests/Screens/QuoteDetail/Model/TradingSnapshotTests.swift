//
//  TradingSnapshotTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct TradingSnapshotTests {
    @Test func initThenKeepsOnlyThisStock() {
        // Given
        let portfolio = Portfolio(
            open: [.dummy(holding: "SAP", quantity: 1), .dummy(holding: "AAPL", quantity: 3)],
            closed: []
        )
        let orders: [Order] = [.dummy("AAPL", status: .filled), .dummy("SAP", status: .filled)]

        // When
        let snapshot = TradingSnapshot(symbol: "AAPL", portfolio: portfolio, orders: orders)

        // Then
        #expect(snapshot.position?.symbol == "AAPL")
        #expect(snapshot.orders.map(\.draft.symbol) == ["AAPL"])
    }
}
