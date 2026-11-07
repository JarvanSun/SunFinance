//
//  SymbolSearchRequestTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore
import Testing

@testable import FinanceCore

struct SymbolSearchRequestTests {
    @Test func requestThenTargetsSearchWithQuery() {
        // Given
        let request = SymbolSearchRequest(query: "sap")

        // Then
        #expect(request.path == ["v1", "search"])
        #expect(request.method == .get)
        #expect(request.queryItems == [URLQueryItem(name: "query", value: "sap")])
        #expect(request.body == nil)
    }
}
