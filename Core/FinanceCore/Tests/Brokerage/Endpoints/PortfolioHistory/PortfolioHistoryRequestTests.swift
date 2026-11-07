//
//  PortfolioHistoryRequestTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore
import Testing

@testable import FinanceCore

struct PortfolioHistoryRequestTests {
    @Test func requestThenReadsTheHistoryOfTheRange() {
        // Given
        let request = PortfolioHistoryRequest(range: .year)

        // Then
        #expect(request.path == ["v1", "portfolio", "history"])
        #expect(request.method == .get)
        #expect(request.queryItems == [URLQueryItem(name: "range", value: "1Y")])
        #expect(request.body == nil)
    }
}
