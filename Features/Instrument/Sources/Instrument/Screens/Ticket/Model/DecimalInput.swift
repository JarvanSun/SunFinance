//
//  DecimalInput.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct DecimalInput: Sendable {
    let locale: Locale

    func parse(_ text: String) -> Decimal? {
        let decimalSeparator = locale.decimalSeparator ?? "."
        let groupingSeparator = locale.groupingSeparator ?? ","
        let normalized =
            text
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: groupingSeparator, with: "")
            .replacingOccurrences(of: decimalSeparator, with: ".")
        let isNumeric =
            !normalized.isEmpty
            && normalized.allSatisfy { $0.isASCII && ($0.isNumber || $0 == ".") }
        guard isNumeric, normalized.filter({ $0 == "." }).count <= 1 else { return nil }

        return Decimal(string: normalized, locale: Locale(identifier: "en_US_POSIX"))
    }

    func text(for value: Decimal) -> String {
        value.formatted(.number.grouping(.never).precision(.fractionLength(0...4)).locale(locale))
    }
}
