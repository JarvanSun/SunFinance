//
//  LocalizationCatalog.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct LocalizationCatalog: Decodable {
    private let strings: [String: Entry]

    init(contentsOf url: URL) throws {
        self = try JSONDecoder().decode(Self.self, from: Data(contentsOf: url))
    }

    func keysMissingTranslation(for language: String) -> [String] {
        strings
            .filter { $0.value.translatedValue(for: language) == nil }
            .map(\.key)
            .sorted()
    }
}

private extension LocalizationCatalog {
    struct Entry: Decodable {
        let localizations: [String: Localization]?

        func translatedValue(for language: String) -> String? {
            guard let unit = localizations?[language]?.stringUnit else { return nil }

            let isTranslated = unit.state == Self.translatedState
            return isTranslated ? unit.value : nil
        }

        private static let translatedState = "translated"
    }

    struct Localization: Decodable {
        let stringUnit: StringUnit?
    }

    struct StringUnit: Decodable {
        let state: String
        let value: String
    }
}
