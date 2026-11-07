//
//  JSONEncoderExtensionsTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct JSONEncoderExtensionsTests {
    @Test func backendThenEncodesDatesAsISO8601() throws {
        // Given
        let date = Date(timeIntervalSince1970: 0)

        // When
        let data = try JSONEncoder.backend.encode([date])

        // Then
        #expect(String(decoding: data, as: UTF8.self) == #"["1970-01-01T00:00:00Z"]"#)
    }
}
