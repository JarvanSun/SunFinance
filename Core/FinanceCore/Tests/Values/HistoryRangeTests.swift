//
//  HistoryRangeTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct HistoryRangeTests {
    @Test func rawValuesThenAreTheShortLabelsTheServerUses() {
        // Then
        #expect(HistoryRange.allCases.map(\.rawValue) == ["1D", "1W", "1M", "3M", "1Y", "5Y"])
    }
}
