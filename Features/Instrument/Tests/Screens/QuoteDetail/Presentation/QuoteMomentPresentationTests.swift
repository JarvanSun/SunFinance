//
//  QuoteMomentPresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct QuoteMomentPresentationTests {
    @Test(arguments: [
        (QuoteMoment.live(isMarketOpen: true), "quoteDetail.header.marketOpen"),
        (.live(isMarketOpen: false), "quoteDetail.header.marketClosed"),
        (.scrubbed(.now, .day), "quoteDetail.header.atTime %@"),
        (.scrubbed(.now, .year), "quoteDetail.header.onDate %@"),
    ])
    func textThenNamesTheMoment(moment: QuoteMoment, key: String) {
        // Then
        #expect(moment.text.key == key)
    }
}
