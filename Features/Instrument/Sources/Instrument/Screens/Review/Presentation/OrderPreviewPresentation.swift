//
//  OrderPreviewPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension OrderPreview {
    func rows(side: TradeSide) -> [LabeledRow] {
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
        let costs = [
            LabeledRow(id: "fee", title: TradingText.feeRow, value: .verbatim(fee.formatted())),
            LabeledRow(
                id: "total",
                title: side.totalRowTitle,
                value: .verbatim(total.formatted()),
                emphasis: .total
            ),
            LabeledRow(
                id: "cashAfter",
                title: TradingText.cashAfterRow,
                value: .verbatim(cashAfter.formatted())
            ),
        ]
        return figures + rate.rows + costs
    }
}

private extension OrderPreview {
    var rate: ExchangeRate {
        ExchangeRate(currency: price.currency, eurosPerUnit: exchangeRate)
    }
}
