//
//  LocalizationCatalogTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

struct LocalizationCatalogTests {
    @Test(arguments: ["en", "de"])
    func catalogThenEveryKeyIsTranslated(language: String) throws {
        // Given
        let catalog = try LocalizationCatalog(contentsOf: catalogURL)

        // When
        let missingKeys = catalog.keysMissingTranslation(for: language)

        // Then
        #expect(missingKeys.isEmpty, "Missing \(language): \(missingKeys)")
    }
}

private extension LocalizationCatalogTests {
    var catalogURL: URL {
        .init(filePath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appending(path: "Sources/DesignSystem/Resources/Localizable.xcstrings")
    }
}
