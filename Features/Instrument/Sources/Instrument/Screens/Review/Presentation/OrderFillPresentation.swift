//
//  OrderFillPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension OrderFill {
    var rows: [LabeledRow] {
        let figures = [
            LabeledRow(
                id: "quantity",
                title: TradingText.quantityRow,
                value: .verbatim(quantity.formattedQuantity())
            ),
            LabeledRow(
                id: "price",
                title: TradingText.priceRow,
                value: .verbatim(price.formatted())
            ),
        ]
        let feeRow = LabeledRow(
            id: "fee",
            title: TradingText.feeRow,
            value: .verbatim(fee.formatted())
        )
        return figures + rate.rows + [feeRow]
    }
}

private extension OrderFill {
    var rate: ExchangeRate {
        ExchangeRate(currency: price.currency, eurosPerUnit: exchangeRate)
    }
}
