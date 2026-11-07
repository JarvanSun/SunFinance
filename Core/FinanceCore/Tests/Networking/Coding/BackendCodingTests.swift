//
//  BackendCodingTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct BackendCodingTests {
    @Test func makeBackendEncoderThenEncodesDatesAsISO8601() throws {
        // Given
        let date = Date(timeIntervalSince1970: 0)

        // When
        let data = try makeBackendEncoder().encode([date])

        // Then
        #expect(String(decoding: data, as: UTF8.self) == #"["1970-01-01T00:00:00Z"]"#)
    }

    @Test func makeBackendDecoderThenDecodesISO8601Dates() throws {
        // Given
        let data = Data(#"["1970-01-01T00:01:40Z"]"#.utf8)

        // When
        let dates = try makeBackendDecoder().decode([Date].self, from: data)

        // Then
        #expect(dates == [Date(timeIntervalSince1970: 100)])
    }

    @Test func makeBackendDecoderWhenDateIsNotISO8601ThenThrows() {
        // Given
        let data = Data(#"["yesterday"]"#.utf8)

        // Then
        #expect(throws: DecodingError.self) {
            try makeBackendDecoder().decode([Date].self, from: data)
        }
    }
}
