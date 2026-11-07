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
        // When
        let state = EstimateState.unavailable

        // Then
        #expect(state.totalText == "–")
        #expect(state.totalValue == 0)
        #expect(!state.isRefreshing)
        #expect(state.totalOpacity == 1)
    }

    @Test func totalWhenRefreshingThenDimsTheLastEstimate() {
        // When
        let state = EstimateState.loading(previous: .init())

        // Then
        #expect(state.totalValue == 369)
        #expect(state.isRefreshing)
        #expect(state.totalOpacity < 1)
    }

    @Test func totalWhenReadyThenShowsItPlainly() {
        // When
        let state = EstimateState.ready(.init())

        // Then
        #expect(state.totalValue == 369)
        #expect(state.totalText != "–")
        #expect(state.totalOpacity == 1)
    }
}
