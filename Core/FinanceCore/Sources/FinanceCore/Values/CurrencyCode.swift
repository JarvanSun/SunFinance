//
//  CurrencyCode.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct CurrencyCode: RawRepresentable, Hashable, Codable, Sendable {
    public let rawValue: String

    public init?(rawValue: String) {
        let isThreeLetters = rawValue.count == 3
        let isUppercaseASCII = rawValue.allSatisfy { $0.isASCII && $0.isUppercase }
        guard isThreeLetters, isUppercaseASCII else { return nil }

        self.rawValue = rawValue
    }
}

extension CurrencyCode {
    public static let eur = Self(knownCode: "EUR")
    public static let usd = Self(knownCode: "USD")

    private init(knownCode: String) {
        rawValue = knownCode
    }
}
