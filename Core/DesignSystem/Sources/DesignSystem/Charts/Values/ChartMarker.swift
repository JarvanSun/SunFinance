//
//  ChartMarker.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct ChartMarker: Hashable, Sendable {
    public enum Kind: Hashable, Sendable {
        case buy
        case sell
    }

    public let date: Date
    public let value: Double
    public let kind: Kind

    public init(date: Date, value: Double, kind: Kind) {
        self.date = date
        self.value = value
        self.kind = kind
    }
}
