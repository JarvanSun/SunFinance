//
//  IdempotencyKey.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct IdempotencyKey: RawRepresentable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init() {
        rawValue = UUID().uuidString
    }
}
