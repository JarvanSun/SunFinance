//
//  SignedPercentFormatStyle.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct SignedPercentFormatStyle: FormatStyle {
    public let locale: Locale

    public init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
    }

    public func format(_ percentPoints: Decimal) -> String {
        (percentPoints / percentScale).formatted(percentStyle)
    }

    public func locale(_ locale: Locale) -> Self {
        .init(locale: locale)
    }
}

private extension SignedPercentFormatStyle {
    var percentScale: Decimal { 100 }

    var fractionDigits: Int { 2 }

    var percentStyle: Decimal.FormatStyle.Percent {
        .percent
            .precision(.fractionLength(fractionDigits))
            .sign(strategy: .always(includingZero: false))
            .locale(locale)
    }
}

extension FormatStyle where Self == SignedPercentFormatStyle {
    public static var signedPercent: Self { .init() }
}
