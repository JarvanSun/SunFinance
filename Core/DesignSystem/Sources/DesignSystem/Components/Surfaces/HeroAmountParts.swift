//
//  HeroAmountParts.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct HeroAmountParts: Equatable {
    let whole: String
    let cents: String
    let leadingSymbol: String?
    let trailingSymbol: String

    init(whole: String, cents: String, leadingSymbol: String?, trailingSymbol: String) {
        self.whole = whole
        self.cents = cents
        self.leadingSymbol = leadingSymbol
        self.trailingSymbol = trailingSymbol
    }

    init(_ money: Money, locale: Locale) {
        let formatted = money.amount.formatted(
            .currency(code: money.currency.rawValue).locale(locale).attributed
        )
        var whole = ""
        var cents = ""
        var symbol = ""
        var symbolLeads = true
        for run in formatted.runs {
            let text = String(formatted[run.range].characters)
            switch (run.numberSymbol, run.numberPart) {
            case (.currency, _):
                symbol = text
                symbolLeads = !whole.contains { $0.isNumber }
            case (.sign, _), (.groupingSeparator, _), (_, .integer):
                whole += text
            case (_, .fraction):
                cents += text
            default:
                break
            }
        }
        self.init(
            whole: whole,
            cents: cents,
            leadingSymbol: symbolLeads ? symbol : nil,
            trailingSymbol: symbolLeads ? Self.raisingSpace : symbol
        )
    }
}

private extension HeroAmountParts {
    static var raisingSpace: String { " " }
}
