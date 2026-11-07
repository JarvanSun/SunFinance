//
//  LabeledRowEmphasis.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum LabeledRowEmphasis: Hashable, Sendable {
    case regular
    case total

    var font: FinanceFont {
        switch self {
        case .regular:
            .body
        case .total:
            .headline
        }
    }

    var titleColor: FinanceColor {
        switch self {
        case .regular:
            .textSecondary
        case .total:
            .textPrimary
        }
    }
}
