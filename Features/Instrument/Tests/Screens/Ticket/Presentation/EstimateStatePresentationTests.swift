//
//  EstimateStatePresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import Instrument

struct EstimateStatePresentationTests {
    @Test func totalWhenNothingIsEstimatedThenShowsADash() {
        // Given / When
        let state = EstimateState.unavailable

        // Then
        #expect(state.totalText == "–")
        #expect(state.totalValue == 0)
        #expect(!state.isRefreshing)
        #expect(state.totalOpacity == 1)
    }

    @Test func totalWhenRefreshingThenDimsTheLastEstimate() {
        // Given / When
        let state = EstimateState.loading(previous: .dummy())

        // Then
        #expect(state.totalValue == 369)
        #expect(state.isRefreshing)
        #expect(state.totalOpacity < 1)
    }

    @Test func totalWhenReadyThenShowsItPlainly() {
        // Given / When
        let state = EstimateState.ready(.dummy())

        // Then
        #expect(state.totalValue == 369)
        #expect(state.totalText != "–")
        #expect(state.totalOpacity == 1)
    }
}
