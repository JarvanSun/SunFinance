//
//  LoadStateTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import DesignSystem

struct LoadStateTests {
    @Test(arguments: [
        (LoadState<Int, String>.idle, Int?.none),
        (.loading, nil),
        (.loaded(3), 3),
        (.failed("offline"), nil),
    ])
    func valueThenExistsOnlyOnceLoaded(state: LoadState<Int, String>, expected: Int?) {
        #expect(state.value == expected)
    }

    @Test(arguments: [
        (LoadState<Int, String>.loaded(1), LoadState<Int, String>.loaded(1)),
        (.idle, .loading),
        (.loading, .loading),
        (.failed("offline"), .loading),
    ])
    func reloadingThenKeepsALoadedValue(
        state: LoadState<Int, String>,
        expected: LoadState<Int, String>
    ) {
        #expect(state.reloading == expected)
    }

    @Test(arguments: [
        (
            LoadState<Int, String>.loaded(1),
            LoadState<Int, String>.failed("offline"),
            LoadState<Int, String>.loaded(1)
        ),
        (.loaded(1), .loaded(2), .loaded(2)),
        (.loading, .failed("offline"), .failed("offline")),
        (.failed("offline"), .loaded(2), .loaded(2)),
    ])
    func settledThenKeepsTheValueOnlyWhenAReloadFails(
        state: LoadState<Int, String>,
        result: LoadState<Int, String>,
        expected: LoadState<Int, String>
    ) {
        #expect(state.settled(with: result) == expected)
    }
}
