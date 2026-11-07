//
//  DecimalExtensions.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension Decimal {
    nonisolated public func formattedQuantity(locale: Locale = .autoupdatingCurrent) -> String {
        formatted(.number.precision(.fractionLength(quantityFractionDigits)).locale(locale))
    }

    nonisolated public func formattedExchangeRate(locale: Locale = .autoupdatingCurrent) -> String {
        formatted(
            .currency(code: CurrencyCode.eur.rawValue)
                .precision(.fractionLength(exchangeRateFractionDigits))
                .locale(locale)
        )
    }
}

private extension Decimal {
    nonisolated var quantityFractionDigits: ClosedRange<Int> { 0...4 }

    nonisolated var exchangeRateFractionDigits: Int { 4 }
}
