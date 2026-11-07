//
//  JSONDecoderExtensionsTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct JSONDecoderExtensionsTests {
    @Test func backendThenDecodesISO8601Dates() throws {
        // Given
        let data = Data(#"["1970-01-01T00:01:40Z"]"#.utf8)

        // When
        let dates = try JSONDecoder.backend.decode([Date].self, from: data)

        // Then
        #expect(dates == [Date(timeIntervalSince1970: 100)])
    }

    @Test func backendWhenDateIsNotISO8601ThenThrows() {
        // Given
        let data = Data(#"["yesterday"]"#.utf8)

        // Then
        #expect(throws: DecodingError.self) {
            try JSONDecoder.backend.decode([Date].self, from: data)
        }
    }
}
