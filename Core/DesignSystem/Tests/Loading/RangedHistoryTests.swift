//
//  RangedHistoryTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import DesignSystem

struct RangedHistoryTests {
    @Test func initThenSelectsTheRangeWithNothingShown() {
        // Given
        let history = makeHistory()

        // Then
        #expect(history.range == "day")
        #expect(history.shown == .idle)
        #expect(history.selected == nil)
    }

    @Test func startLoadingWhenNothingIsShownThenLoads() {
        // Given
        var history = makeHistory()

        // When
        history.startLoading()

        // Then
        #expect(history.shown == .loading)
    }

    @Test func settleWhenTheSelectedRangeLoadsThenShowsAndSelectsIt() {
        // Given
        var history = makeHistory()
        history.startLoading()

        // When
        history.settle(with: .loaded(1), for: "day")

        // Then
        #expect(history.shown == .loaded(1))
        #expect(history.selected == 1)
    }

    @Test func selectWhenTheRangeIsCachedThenShowsItAtOnce() {
        // Given
        var history = makeHistory()
        history.settle(with: .loaded(1), for: "day")
        history.select("year")
        history.settle(with: .loaded(2), for: "year")

        // When
        history.select("day")

        // Then
        #expect(history.shown == .loaded(1))
        #expect(history.selected == 1)
    }

    @Test func selectWhenTheRangeIsNewThenKeepsTheOldCurveOnlyAsMorphSource() {
        // Given
        var history = makeHistory()
        history.settle(with: .loaded(1), for: "day")

        // When
        history.select("year")
        history.startLoading()

        // Then
        #expect(history.range == "year")
        #expect(history.shown == .loaded(1))
        #expect(history.selected == nil)
    }

    @Test func settleWhenANewRangeFailsThenShowsTheIssueInsteadOfTheOldCurve() {
        // Given
        var history = makeHistory()
        history.settle(with: .loaded(1), for: "day")
        history.select("year")

        // When
        history.settle(with: .failed("offline"), for: "year")

        // Then
        #expect(history.shown == .failed("offline"))
        #expect(history.selected == nil)
    }

    @Test func settleWhenARangeWithItsOwnDataFailsThenKeepsItsData() {
        // Given
        var history = makeHistory()
        history.settle(with: .loaded(1), for: "day")
        history.startLoading()

        // When
        history.settle(with: .failed("offline"), for: "day")

        // Then
        #expect(history.shown == .loaded(1))
        #expect(history.selected == 1)
    }

    @Test func settleWhenTheRangeChangedMeanwhileThenOnlyCachesTheOldRange() {
        // Given
        var history = makeHistory()
        history.startLoading()
        history.select("year")

        // When
        history.settle(with: .loaded(1), for: "day")
        let shownAfterStaleAnswer = history.shown
        history.select("day")

        // Then
        #expect(shownAfterStaleAnswer == .loading)
        #expect(history.shown == .loaded(1))
    }

    @Test func settleWhenAStaleRangeFailsThenChangesNothing() {
        // Given
        var history = makeHistory()
        history.settle(with: .loaded(1), for: "day")
        history.select("year")

        // When
        history.settle(with: .failed("offline"), for: "day")

        // Then
        #expect(history.shown == .loaded(1))
        #expect(history.selected == nil)
    }

    @Test(arguments: [LoadState<Int, String>.idle, .loading])
    func settleWhenTheResultIsNotFinalThenChangesNothing(result: LoadState<Int, String>) {
        // Given
        var history = makeHistory()
        history.settle(with: .loaded(1), for: "day")

        // When
        history.settle(with: result, for: "day")

        // Then
        #expect(history.shown == .loaded(1))
    }

    @Test func selectWhenTheShownRangeFailedThenLoads() {
        // Given
        var history = makeHistory()
        history.settle(with: .failed("offline"), for: "day")

        // When
        history.select("year")

        // Then
        #expect(history.shown == .loading)
    }
}

private extension RangedHistoryTests {
    func makeHistory() -> RangedHistory<String, Int, String> {
        RangedHistory(range: "day")
    }
}
