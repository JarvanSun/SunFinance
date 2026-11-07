//
//  PriceChangeTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct PriceChangeTests {
    @Test func amountAndPercentThenCompareEndWithStart() {
        // Given
        let change = PriceChange(start: Money(200, .usd), end: Money(210, .usd))

        // Then
        #expect(change.amount == Money(10, .usd))
        #expect(change.percent == 5)
    }
}
