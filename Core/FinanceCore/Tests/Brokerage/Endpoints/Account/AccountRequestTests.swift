//
//  AccountRequestTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore
import Testing

@testable import FinanceCore

struct AccountRequestTests {
    @Test func requestThenReadsTheAccount() {
        // Given
        let request = AccountRequest()

        // Then
        #expect(request.path == ["v1", "account"])
        #expect(request.method == .get)
        #expect(request.queryItems.isEmpty)
        #expect(request.body == nil)
    }
}
