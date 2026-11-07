//
//  StringExtensionsTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct StringExtensionsTests {
    @Test(arguments: [("", true), ("  \n", true), (" a ", false)])
    func isBlankThenIsTrueOnlyForWhitespace(text: String, expected: Bool) {
        #expect(text.isBlank == expected)
    }
}
