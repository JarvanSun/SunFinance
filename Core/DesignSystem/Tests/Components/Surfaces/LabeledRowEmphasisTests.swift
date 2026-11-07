//
//  LabeledRowEmphasisTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import DesignSystem

struct LabeledRowEmphasisTests {
    @Test(arguments: [
        (LabeledRowEmphasis.regular, FinanceFont.body, FinanceColor.textSecondary),
        (.total, .headline, .textPrimary),
    ])
    func styleThenSetsTheTotalApart(
        emphasis: LabeledRowEmphasis,
        font: FinanceFont,
        titleColor: FinanceColor
    ) {
        // Then
        #expect(emphasis.font == font)
        #expect(emphasis.titleColor == titleColor)
    }
}
