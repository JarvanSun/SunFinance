//
//  GainTrend.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public enum GainTrend: Equatable, Sendable {
    case gain
    case loss
    case unchanged

    public init(_ change: Decimal) {
        switch change {
        case ..<0:
            self = .loss
        case 0:
            self = .unchanged
        default:
            self = .gain
        }
    }

    public init(from start: Double, to end: Double) {
        switch end - start {
        case ..<0:
            self = .loss
        case 0:
            self = .unchanged
        default:
            self = .gain
        }
    }

    public var color: FinanceColor {
        switch self {
        case .gain: .gain
        case .loss: .loss
        case .unchanged: .unchanged
        }
    }
}
