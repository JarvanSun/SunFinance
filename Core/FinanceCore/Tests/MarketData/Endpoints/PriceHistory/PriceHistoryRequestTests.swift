//
//  PriceHistoryRequestTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore
import Testing

@testable import FinanceCore

struct PriceHistoryRequestTests {
    @Test func requestThenTargetsHistoryWithRange() {
        // Given
        let request = PriceHistoryRequest(symbol: "SAP", range: .threeMonths)

        // Then
        #expect(request.path == ["v1", "symbols", "SAP", "history"])
        #expect(request.method == .get)
        #expect(request.queryItems == [URLQueryItem(name: "range", value: "3M")])
    }
}
