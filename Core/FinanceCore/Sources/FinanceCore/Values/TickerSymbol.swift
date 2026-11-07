//
//  TickerSymbol.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct TickerSymbol: RawRepresentable, Hashable, Comparable, Codable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue.uppercased()
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension TickerSymbol: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
