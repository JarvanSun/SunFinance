//
//  OrderListLoadsTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import Orders

struct OrderListLoadsTests {
    @Test func phaseBeforeAnyLoadThenIsIdle() {
        // Given
        let loads = OrderListLoads()

        // Then
        #expect(loads.phase == .idle)
    }

    @Test func startThenLoadsUntilTheLoadFinishes() {
        // Given
        var loads = OrderListLoads()

        // When
        let load = loads.start()
        let phaseWhileLoading = loads.phase
        let isApplied = loads.finish(load, settling: .loaded)

        // Then
        #expect(phaseWhileLoading == .loading)
        #expect(isApplied)
        #expect(loads.phase == .loaded)
    }

    @Test func finishWhenAnotherLoadIsStillRunningThenKeepsLoading() {
        // Given
        var loads = OrderListLoads()
        let first = loads.start()
        _ = loads.start()

        // When
        let isApplied = loads.finish(first, settling: .loaded)

        // Then
        #expect(isApplied)
        #expect(loads.phase == .loading)
    }

    @Test func abandonWhenTheOtherLoadFinishedThenSettlesOnItsPhase() {
        // Given
        var loads = OrderListLoads()
        let first = loads.start()
        _ = loads.start()
        _ = loads.finish(first, settling: .loaded)

        // When
        loads.abandon()

        // Then
        #expect(loads.phase == .loaded)
    }

    @Test func abandonWhenItWasTheOnlyLoadThenReturnsToTheSettledPhase() {
        // Given
        var loads = OrderListLoads()
        _ = loads.start()

        // When
        loads.abandon()

        // Then
        #expect(loads.phase == .idle)
    }

    @Test func finishWhenANewerLoadAlreadySettledThenIsNotApplied() {
        // Given
        var loads = OrderListLoads()
        let older = loads.start()
        let newer = loads.start()
        _ = loads.finish(newer, settling: .loaded)

        // When
        let isApplied = loads.finish(older, settling: .failed(.offline))

        // Then
        #expect(!isApplied)
        #expect(loads.phase == .loaded)
    }
}
