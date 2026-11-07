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
            [LabeledRow(id: "rate", title: TradingText.rateRow, value: .localized(valueText))]
        }
    }
}

private extension ExchangeRate {
    var valueText: LocalizedStringResource {
        TradingText.rate(
            currency: currency.rawValue,
            inEuros: eurosPerUnit.formattedExchangeRate()
        )
    }
}
