//
//  BundleExtensionsTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct BundleExtensionsTests {
    @Test func fixtureWhenFileExistsThenDecodesIt() throws {
        // Given / When
        let listings = try Bundle.module.fixture(named: "listings", as: MockListingsDTO.self)

        // Then
        #expect(!listings.listings.isEmpty)
        #expect(listings.eurPerUSD > 0)
    }

    @Test func fixtureWhenFileIsMissingThenThrows() {
        #expect(throws: CocoaError.self) {
            try Bundle.module.fixture(named: "missing", as: MockListingsDTO.self)
        }
    }
}
