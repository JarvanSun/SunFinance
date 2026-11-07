//
//  PlacementStatePresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct PlacementStatePresentationTests {
    @Test(arguments: [
        (PlacementState.ready, SlideToConfirmPhase.ready, false),
        (.placing, .working, false),
        (.placed(.init(status: .filled)), .done, false),
        (.failed(.offline), .ready, true),
    ])
    func slidePhaseThenFollowsThePlacement(
        state: PlacementState,
        phase: SlideToConfirmPhase,
        isFailed: Bool
    ) {
        // Then
        #expect(state.slidePhase == phase)
        #expect(state.isFailed == isFailed)
    }

    @Test(arguments: [
        (PlacementState.failed(.offline), "trading.review.placeFailed.offline"),
        (.failed(.serviceUnavailable), "trading.review.placeFailed.service"),
        (.ready, "trading.review.placeFailed.service"),
    ])
    func failureMessageThenNamesWhyPlacingGotNoAnswer(state: PlacementState, key: String) {
        // Then
        #expect(state.failureMessage.key == key)
    }
}
