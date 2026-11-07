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
                title: .init("trading.review.row.quantity", bundle: .module),
                value: .verbatim(quantity.formattedQuantity())
            ),
            LabeledRow(
                id: "price",
                title: .init("trading.review.row.price", bundle: .module),
                value: .verbatim(price.formatted())
            ),
        ]
        let costs = [
            LabeledRow(
                id: "fee",
                title: .init("trading.review.row.fee", bundle: .module),
                value: .verbatim(fee.formatted())
            ),
            LabeledRow(
                id: "total",
                title: side.totalRowTitle,
                value: .verbatim(total.formatted()),
                emphasis: .total
            ),
            LabeledRow(
                id: "cashAfter",
                title: .init("trading.review.row.cashAfter", bundle: .module),
                value: .verbatim(cashAfter.formatted())
            ),
        ]
        return figures + rate.rows + costs
    }
}

private extension OrderPreview {
    var rate: ExchangeRate {
        .init(currency: price.currency, eurosPerUnit: exchangeRate)
    }
}
