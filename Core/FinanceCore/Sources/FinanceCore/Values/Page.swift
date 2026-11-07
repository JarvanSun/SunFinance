//
//  Page.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct Page<Element: Sendable>: Sendable {
    public let elements: [Element]
    public let nextCursor: String?

    public var hasMore: Bool { nextCursor != nil }

    public init(elements: [Element], nextCursor: String?) {
        self.elements = elements
        self.nextCursor = nextCursor
    }
}

extension Page: Equatable where Element: Equatable {}
