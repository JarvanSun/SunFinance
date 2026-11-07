//
//  ExchangeRatePresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension ExchangeRate {
    var rows: [LabeledRow] {
        switch currency == .eur {
        case true:
            []
        case false:
            [
                LabeledRow(
                    id: "rate",
                    title: .init("trading.review.row.rate", bundle: .module),
                    value: .localized(valueText)
                )
            ]
        }
    }
}

private extension ExchangeRate {
    var valueText: LocalizedStringResource {
        let inEuros = eurosPerUnit.formattedExchangeRate()
        return .init(
            "trading.review.row.rate.value \(currency.rawValue) \(inEuros)",
            bundle: .module
        )
    }
}
