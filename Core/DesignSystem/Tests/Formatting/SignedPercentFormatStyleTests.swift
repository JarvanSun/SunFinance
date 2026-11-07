//
//  SignedPercentFormatStyleTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

struct SignedPercentFormatStyleTests {
    @Test(arguments: [
        (Decimal(1.24), "en_US", "+1.24%"),
        (-0.38, "en_US", "-0.38%"),
        (0, "en_US", "0.00%"),
        (1.24, "de_DE", "+1,24\u{00A0}%"),
    ])
    func formatThenAddsSignAndKeepsTwoFractionDigits(
        percentPoints: Decimal,
        localeIdentifier: String,
        expected: String
    ) {
        // Given
        let style = SignedPercentFormatStyle(locale: Locale(identifier: localeIdentifier))

        // When
        let formatted = style.format(percentPoints)

        // Then
        #expect(formatted == expected)
    }
}
