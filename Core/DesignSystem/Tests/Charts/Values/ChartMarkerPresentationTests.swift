//
//  ChartMarkerPresentationTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import DesignSystem

struct ChartMarkerPresentationTests {
    @Test(arguments: [(ChartMarker.Kind.buy, FinanceColor.gain), (.sell, .loss)])
    func colorThenBuyIsGainAndSellIsLoss(kind: ChartMarker.Kind, expected: FinanceColor) {
        // When
        let color = kind.color

        // Then
        #expect(color == expected)
    }
}
