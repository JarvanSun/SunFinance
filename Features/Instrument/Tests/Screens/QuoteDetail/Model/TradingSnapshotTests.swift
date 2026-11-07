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
            open: [.init(holding: "SAP", quantity: 1), .init(holding: "AAPL", quantity: 3)],
            closed: []
        )
        let orders: [Order] = [.init("AAPL", status: .filled), .init("SAP", status: .filled)]

        // When
        let snapshot = TradingSnapshot(symbol: "AAPL", portfolio: portfolio, orders: orders)

        // Then
        #expect(snapshot.position?.symbol == "AAPL")
        #expect(snapshot.orders.map(\.draft.symbol) == ["AAPL"])
    }
}
