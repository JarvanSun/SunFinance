//
//  FavoriteActionPresentationTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

@testable import Watchlist

struct FavoriteActionPresentationTests {
    @Test(arguments: [(FavoriteAction.add, FinanceImage.favorite), (.remove, .removeFavorite)])
    func swipeImageThenShowsTheAction(action: FavoriteAction, expected: FinanceImage) {
        // Then
        #expect(action.swipeImage == expected)
    }

    @Test(arguments: [(FavoriteAction.add, FinanceImage?.none), (.remove, .favorite)])
    func rowBadgeThenMarksOnlyFavorites(action: FavoriteAction, expected: FinanceImage?) {
        // Then
        #expect(action.rowBadge == expected)
    }

    @Test func titleThenEveryActionHasItsOwnKey() {
        // Then
        #expect(FavoriteAction.add.title.key != FavoriteAction.remove.title.key)
    }
}
