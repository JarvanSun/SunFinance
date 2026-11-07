//
//  OrderDetailPresentation.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension Order {
    var detailSections: [OrderDetailSection] {
        let terms = OrderDetailSection(id: "terms", rows: termRows)
        return switch fill {
        case .some(let fill):
            [terms, OrderDetailSection(id: "fill", rows: rows(of: fill))]
        case nil:
            [terms]
        }
    }

    var totalTitle: LocalizedStringResource {
        switch draft.side {
        case .buy:
            .init("orders.detail.row.total.buy", bundle: .module)
        case .sell:
            .init("orders.detail.row.total.sell", bundle: .module)
        }
    }
}

private extension Order {
    var termRows: [LabeledRow] {
        [
            LabeledRow(
                id: "placed",
                title: OrdersText.placedRow,
                value: .verbatim(createdAt.formatted(date: .abbreviated, time: .shortened))
            ),
            LabeledRow(id: "type", title: OrdersText.typeRow, value: .localized(executionText)),
            LabeledRow(id: "trigger", title: OrdersText.triggerRow, value: .localized(triggerText)),
            LabeledRow(
                id: "validity",
                title: OrdersText.validityRow,
                value: .localized(validityText)
            ),
            LabeledRow(
                id: "quantity",
                title: OrdersText.quantityRow,
                value: .verbatim(quantity.formattedQuantity())
            ),
        ]
    }

    func rows(of fill: OrderFill) -> [LabeledRow] {
        let figures = [
            LabeledRow(
                id: "filled",
                title: OrdersText.filledRow,
                value: .verbatim(fill.date.formatted(date: .abbreviated, time: .shortened))
            ),
            LabeledRow(
                id: "price",
                title: OrdersText.priceRow,
                value: .verbatim(fill.price.formatted())
            ),
        ]
        let costs = [
            LabeledRow(id: "fee", title: OrdersText.feeRow, value: .verbatim(fill.fee.formatted())),
            LabeledRow(
                id: "total",
                title: totalTitle,
                value: .verbatim(fill.total.formatted()),
                emphasis: .total
            ),
        ]
        return figures + rateRows(of: fill) + costs
    }

    func rateRows(of fill: OrderFill) -> [LabeledRow] {
        let rate = OrdersText.rate(
            currency: fill.price.currency.rawValue,
            inEuros: fill.exchangeRate.formattedExchangeRate()
        )
        return switch fill.price.currency == .eur {
        case true:
            []
        case false:
            [LabeledRow(id: "rate", title: OrdersText.rateRow, value: .localized(rate))]
        }
    }
}
