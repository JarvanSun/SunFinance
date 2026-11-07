//
//  TradingEventTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct TradingEventTests {
    @Test(arguments: [
        (OrderDraft(), "market", "now"),
        (.init(execution: .limit(1)), "limit", "now"),
        (.init(trigger: .priceAtOrAbove(1)), "stop", "price"),
        (.init(execution: .limit(1), trigger: .priceAtOrBelow(1)), "stop_limit", "price"),
        (.init(trigger: .at(testNow)), "market", "time"),
    ])
    func orderReviewedThenDescribesTypeAndTrigger(
        draft: OrderDraft,
        orderType: String,
        trigger: String
    ) {
        // When
        let parameters = TradingEvent.orderReviewed(draft).parameters

        // Then
        #expect(parameters[.orderType] == .text(orderType))
        #expect(parameters[.trigger] == .text(trigger))
    }

    @Test func orderPlacedThenCarriesStatusButNoSize() {
        // When
        let event = TradingEvent.orderPlaced(.init(status: .filled))

        // Then
        #expect(event.name == .init("trading_order_placed"))
        #expect(event.parameters[.status] == .text("filled"))
        #expect(Set(event.parameters.keys) == [.symbol, .side, .orderType, .trigger, .status])
    }

    @Test func ticketOpenedThenNamesTheSource() {
        // When
        let event = TradingEvent.ticketOpened(
            TradeIntent(symbol: "SAP", side: .sell, source: .position)
        )

        // Then
        #expect(event.parameters[.source] == .text("position"))
    }
}
