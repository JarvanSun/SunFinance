//
//  MoneyExtensions.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension Money {
    nonisolated public func formatted(locale: Locale = .autoupdatingCurrent) -> String {
        amount.formatted(.currency(code: currency.rawValue).locale(locale))
    }

    nonisolated public func formattedSigned(locale: Locale = .autoupdatingCurrent) -> String {
        amount.formatted(
            .currency(code: currency.rawValue)
                .sign(strategy: .always(showZero: false))
                .locale(locale)
        )
    }

    nonisolated public var doubleValue: Double {
        NSDecimalNumber(decimal: amount).doubleValue
    }
}
