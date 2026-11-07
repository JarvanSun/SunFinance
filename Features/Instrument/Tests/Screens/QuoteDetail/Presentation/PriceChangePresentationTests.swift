//
//  PriceChangePresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct PriceChangePresentationTests {
    @Test(arguments: [
        (Decimal(110), GainTrend.gain, "+"),
        (90, .loss, "-"),
        (100, .unchanged, ""),
    ])
    func presentationThenSignsTheChange(end: Decimal, trend: GainTrend, sign: String) {
        // Given
        let change = PriceChange(start: Money(100, .usd), end: Money(end, .usd))

        // Then
        #expect(change.trend == trend)
        #expect(change.percentText.hasPrefix(sign))
        #expect(change.amountText.hasPrefix(sign))
    }
}
