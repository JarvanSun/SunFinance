//
//  QuoteDetailEventTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Instrument

struct QuoteDetailEventTests {
    @Test(arguments: [
        (
            QuoteDetailEvent.screenViewed(symbol: "AAPL"), "quote_detail_viewed",
            ["symbol": AnalyticsValue.text("AAPL")]
        ),
        (
            .rangeChanged(symbol: "AAPL", range: .year), "quote_detail_range_changed",
            ["symbol": .text("AAPL"), "range": .text("1Y")]
        ),
        (
            .chartStyleChanged(.candles), "quote_detail_chart_style_changed",
            ["chart_style": .text("candles")]
        ),
        (
            .chartScrubbed(symbol: "SAP", range: .day), "quote_detail_chart_scrubbed",
            ["symbol": .text("SAP"), "range": .text("1D")]
        ),
    ])
    func eventThenHasNameAndParameters(
        event: QuoteDetailEvent,
        name: String,
        parameters: [String: AnalyticsValue]
    ) {
        // Then
        #expect(event.name.rawValue == name)
        #expect(
            Dictionary(uniqueKeysWithValues: event.parameters.map { ($0.key.rawValue, $0.value) })
                == parameters
        )
    }
}
