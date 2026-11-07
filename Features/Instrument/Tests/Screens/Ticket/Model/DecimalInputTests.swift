//
//  DecimalInputTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import Instrument

struct DecimalInputTests {
    @Test(arguments: [
        ("en_US", "1,234.5", Decimal(string: "1234.5")),
        ("de_DE", "1.234,5", Decimal(string: "1234.5")),
        ("de_DE", "0,0001", Decimal(string: "0.0001")),
        ("en_US", " 12 ", Decimal(12)),
        ("en_US", "12a", nil),
        ("en_US", "1.2.3", nil),
        ("en_US", "", nil),
        ("en_US", "-3", nil),
    ])
    func parseThenReadsTheLocalesNumbers(locale: String, text: String, expected: Decimal?) {
        // When
        let value = DecimalInput(locale: Locale(identifier: locale)).parse(text)

        // Then
        #expect(value == expected)
    }

    @Test func textWhenGermanThenUsesCommaWithoutGrouping() {
        // When
        let text = DecimalInput(locale: Locale(identifier: "de_DE")).text(
            for: Decimal(string: "1234.5")!
        )

        // Then
        #expect(text == "1234,5")
    }
}
