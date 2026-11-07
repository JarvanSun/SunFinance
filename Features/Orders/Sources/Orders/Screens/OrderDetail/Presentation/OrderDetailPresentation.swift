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
        case .some(let fill): [terms, OrderDetailSection(id: "fill", rows: rows(of: fill))]
        case nil: [terms]
        }
    }

    var totalTitle: LocalizedStringResource {
        switch draft.side {
        case .buy: .init("orders.detail.row.total.buy", bundle: .module)
        case .sell: .init("orders.detail.row.total.sell", bundle: .module)
        }
    }
}

private extension Order {
    var termRows: [LabeledRow] {
        [
            .init(
                id: "placed",
                title: .init("orders.detail.row.placed", bundle: .module),
                value: .verbatim(createdAt.formatted(date: .abbreviated, time: .shortened))
            ),
            .init(
                id: "type",
                title: .init("orders.detail.row.type", bundle: .module),
                value: .localized(executionText)
            ),
            .init(
                id: "trigger",
                title: .init("orders.detail.row.trigger", bundle: .module),
                value: .localized(triggerText)
            ),
            .init(
                id: "validity",
                title: .init("orders.detail.row.validity", bundle: .module),
                value: .localized(validityText)
            ),
            .init(
                id: "quantity",
                title: .init("orders.detail.row.quantity", bundle: .module),
                value: .verbatim(quantity.formattedQuantity())
            ),
        ]
    }

    func rows(of fill: OrderFill) -> [LabeledRow] {
        let figures = [
            LabeledRow(
                id: "filled",
                title: .init("orders.detail.row.filled", bundle: .module),
                value: .verbatim(fill.date.formatted(date: .abbreviated, time: .shortened))
            ),
            LabeledRow(
                id: "price",
                title: .init("orders.detail.row.price", bundle: .module),
                value: .verbatim(fill.price.formatted())
            ),
        ]
        let costs = [
            LabeledRow(
                id: "fee",
                title: .init("orders.detail.row.fee", bundle: .module),
                value: .verbatim(fill.fee.formatted())
            ),
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
        let currency = fill.price.currency.rawValue
        let inEuros = fill.exchangeRate.formattedExchangeRate()
        let rate = LocalizedStringResource(
            "orders.detail.row.rate.value \(currency) \(inEuros)",
            bundle: .module
        )
        return switch fill.price.currency == .eur {
        case true: []
        case false:
            [
                LabeledRow(
                    id: "rate",
                    title: .init("orders.detail.row.rate", bundle: .module),
                    value: .localized(rate)
                )
            ]
        }
    }
}
