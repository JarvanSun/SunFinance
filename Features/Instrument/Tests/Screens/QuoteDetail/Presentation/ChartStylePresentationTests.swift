//
//  ChartStylePresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import Instrument

struct ChartStylePresentationTests {
    @Test(arguments: [
        (ChartStyle.line, "quoteDetail.chartStyle.line"),
        (.candles, "quoteDetail.chartStyle.candles"),
    ])
    func titleThenNamesTheStyle(style: ChartStyle, key: String) {
        #expect(style.title.key == key)
    }
}
