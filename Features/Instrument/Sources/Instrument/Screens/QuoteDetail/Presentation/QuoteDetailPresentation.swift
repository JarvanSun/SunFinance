//
//  QuoteDetailPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension QuoteDetail {
    var statisticRows: [StatisticRow] {
        [
            StatisticRow(
                title: .init("quoteDetail.statistics.open", bundle: .module),
                value: open.formatted()
            ),
            StatisticRow(
                title: .init("quoteDetail.statistics.dayRange", bundle: .module),
                value: rangeText(dayRange)
            ),
            StatisticRow(
                title: .init("quoteDetail.statistics.yearRange", bundle: .module),
                value: rangeText(yearRange)
            ),
            StatisticRow(
                title: .init("quoteDetail.statistics.marketCap", bundle: .module),
                value: quote.marketCap.amount.formatted(
                    .compactCurrency(code: quote.marketCap.currency)
                )
            ),
            StatisticRow(
                title: .init("quoteDetail.statistics.volume", bundle: .module),
                value: volume.formatted(.number.notation(.compactName))
            ),
        ]
    }
}

private extension QuoteDetail {
    func rangeText(_ range: ClosedRange<Decimal>) -> String {
        let style = Decimal.FormatStyle.number.precision(.fractionLength(2))
        let lower = range.lowerBound.formatted(style)
        let upper = range.upperBound.formatted(style)
        let text = LocalizedStringResource(
            "quoteDetail.statistics.range \(lower) \(upper)",
            bundle: .module
        )
        return String(localized: text)
    }
}
