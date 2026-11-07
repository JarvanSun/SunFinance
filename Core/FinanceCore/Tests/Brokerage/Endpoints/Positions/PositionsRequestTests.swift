//
//  PositionsRequestTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore
import Testing

@testable import FinanceCore

struct PositionsRequestTests {
    @Test func requestThenReadsThePositions() {
        // Given
        let request = PositionsRequest()

        // Then
        #expect(request.path == ["v1", "portfolio", "positions"])
        #expect(request.method == .get)
        #expect(request.queryItems.isEmpty)
        #expect(request.body == nil)
    }
}
