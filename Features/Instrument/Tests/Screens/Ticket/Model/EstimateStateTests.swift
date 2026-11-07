//
//  EstimateStateTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Instrument

struct EstimateStateTests {
    @Test(arguments: [
        (EstimateState.unavailable, OrderPreview?.none),
        (.loading(previous: nil), nil),
        (.loading(previous: .dummy()), .dummy()),
        (.ready(.dummy()), .dummy()),
    ])
    func previewThenKeepsTheLastEstimateWhileLoading(
        state: EstimateState,
        expected: OrderPreview?
    ) {
        #expect(state.preview == expected)
    }
}
