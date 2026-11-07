//
//  CompactCurrencyFormatStyle.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

public struct CompactCurrencyFormatStyle: FormatStyle {
    public let currency: CurrencyCode
    public let locale: Locale

    public init(currency: CurrencyCode, locale: Locale = .autoupdatingCurrent) {
        self.currency = currency
        self.locale = locale
    }

    public func format(_ value: Decimal) -> String {
        value.formatted(
            .currency(code: currency.rawValue)
                .notation(.compactName)
                .precision(.significantDigits(significantDigits))
                .locale(locale)
        )
    }

    public func locale(_ locale: Locale) -> Self {
        .init(currency: currency, locale: locale)
    }
}

private extension CompactCurrencyFormatStyle {
    var significantDigits: ClosedRange<Int> { 1...3 }
}

extension FormatStyle where Self == CompactCurrencyFormatStyle {
    public static func compactCurrency(code: CurrencyCode) -> Self {
        .init(currency: code)
    }
}
