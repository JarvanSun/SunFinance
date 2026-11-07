//
//  SymbolAdditionPresentationTests.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

@testable import Watchlist

struct SymbolAdditionPresentationTests {
    @Test(arguments: [
        (SymbolAddition.available, WatchlistImage.addSymbol, FinanceColor.accent, true),
        (.added, .symbolAdded, .textSecondary, false),
    ])
    func presentationThenOffersOnlyWhatCanBeAdded(
        addition: SymbolAddition,
        image: WatchlistImage,
        color: FinanceColor,
        isAvailable: Bool
    ) {
        // Then
        #expect(addition.image == image)
        #expect(addition.imageColor == color)
        #expect(addition.isAvailable == isAvailable)
    }

    @Test func accessibilityHintThenDiffersPerState() {
        // Then
        #expect(SymbolAddition.available.accessibilityHint.key == "watchlist.match.add.hint")
        #expect(SymbolAddition.added.accessibilityHint.key == "watchlist.match.added.hint")
    }
}
