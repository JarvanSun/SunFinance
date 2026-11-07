//
//  AnalyticsEventName.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct AnalyticsEventName: RawRepresentable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }
}
