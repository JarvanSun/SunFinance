//
//  DecimalExtensionsTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import Testing

struct DecimalExtensionsTests {
    @Test(arguments: [
        (Decimal(3), "en_US", "3"),
        (Decimal(string: "1.5")!, "de_DE", "1,5"),
        (Decimal(string: "0.123456")!, "en_US", "0.1235"),
        (Decimal(1_500), "en_US", "1,500"),
    ])
    func formattedQuantityThenShowsUpToFourDecimals(
        quantity: Decimal,
        localeIdentifier: String,
        expected: String
    ) {
        // Given / When
        let text = quantity.formattedQuantity(locale: Locale(identifier: localeIdentifier))

        // Then
        #expect(text == expected)
    }

    @Test(arguments: [
        (Decimal(string: "0.9213")!, "en_US", "€0.9213"),
        (Decimal(string: "0.92")!, "de_DE", "0,9200\u{00A0}€"),
        (Decimal(1), "en_US", "€1.0000"),
    ])
    func formattedExchangeRateThenShowsFourDecimalsInEuros(
        rate: Decimal,
        localeIdentifier: String,
        expected: String
    ) {
        // Given / When
        let text = rate.formattedExchangeRate(locale: Locale(identifier: localeIdentifier))

        // Then
        #expect(text == expected)
    }
}
