//
//  FinanceButtonKind.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum FinanceButtonKind: CaseIterable, Sendable {
    case primary
    case secondary
    case tertiary
    case destructive
    case row
}

extension FinanceButtonKind {
    var foreground: FinanceColor {
        switch self {
        case .primary, .destructive: .textOnAccent
        case .secondary, .tertiary: .accent
        case .row: .textPrimary
        }
    }

    func fill(isPressed: Bool) -> FinanceColor? {
        switch (self, isPressed) {
        case (.primary, _): .accent
        case (.destructive, _): .critical
        case (.row, true): .surfaceElevated
        case (.secondary, _), (.tertiary, _), (.row, false): nil
        }
    }

    var border: FinanceColor? {
        switch self {
        case .secondary: .accent
        case .primary, .tertiary, .destructive, .row: nil
        }
    }

    var font: FinanceFont {
        switch self {
        case .primary, .secondary, .destructive: .headline
        case .tertiary: .callout
        case .row: .body
        }
    }

    var fillsWidth: Bool {
        switch self {
        case .primary, .secondary, .destructive, .row: true
        case .tertiary: false
        }
    }

    var hasPadding: Bool {
        switch self {
        case .primary, .secondary, .tertiary, .destructive: true
        case .row: false
        }
    }

    var dimsWhenPressed: Bool {
        switch self {
        case .primary, .secondary, .tertiary, .destructive: true
        case .row: false
        }
    }
}
