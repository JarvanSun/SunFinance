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
        // When
        let listings = try Bundle.module.fixture(named: "listings", as: MockListingsDTO.self)

        // Then
        #expect(!listings.listings.isEmpty)
        #expect(listings.eurPerUSD > 0)
    }

    @Test func fixtureWhenFileIsMissingThenThrows() {
        // Then
        #expect(throws: CocoaError.self) {
            try Bundle.module.fixture(named: "missing", as: MockListingsDTO.self)
        }
    }
}
