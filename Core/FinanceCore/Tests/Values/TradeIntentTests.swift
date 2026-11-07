//
//  TradeIntentTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct TradeIntentTests {
    @Test func idThenDiffersBySymbolAndSide() {
        // Given
        let buy = TradeIntent(symbol: "SAP", side: .buy, source: .quoteDetail)
        let sell = TradeIntent(symbol: "SAP", side: .sell, source: .position)

        // Then
        #expect(buy.id == "SAP-buy")
        #expect(buy.id != sell.id)
    }
}
